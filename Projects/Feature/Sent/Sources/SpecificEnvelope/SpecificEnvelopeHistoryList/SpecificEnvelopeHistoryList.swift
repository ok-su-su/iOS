//
//  SpecificEnvelopeHistoryList.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSAlert
import SSCreateEnvelope
import SSNotification

// MARK: - SpecificEnvelopeHistoryList

@Reducer
struct SpecificEnvelopeHistoryList: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var envelopePriceProgressProperty: EnvelopePriceProgressProperty {
      .init(
        leadingPriceValue: envelopeProperty.totalSentPrice,
        trailingPriceValue: envelopeProperty.totalReceivedPrice
      )
    }

    var isDeleteAlertPresent = false
    var header: HeaderViewFeature.State
    var envelopeProperty: EnvelopeProperty
    var envelopeContents: [EnvelopeContent] = []
    var isLoading: Bool = false
    var page = 0
    var isEndOfPage: Bool = false
    var isPresentCreateEnvelope: Bool = false

    /// This is a variable that decides whether or not to perform \
    /// an envelope update when the view is dismissed.
    var isUpdateEnvelopePropertyAtMain: Bool = false

    init(envelopeProperty: EnvelopeProperty) {
      self.envelopeProperty = envelopeProperty
      header = .init(.init(title: envelopeProperty.envelopeTargetUserNameText, type: .depth2Text("삭제")))
    }
  }

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case presentAlert(Bool)
    case tappedSpecificEnvelope(EnvelopeContent)
    case tappedAlertConfirmButton
    case onAppearDetail(EnvelopeContent)
    case presentCreateEnvelope(Bool)
    case finishedCreateEnvelopes(Data)
    case tappedFloatingButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .merge(
        .send(.async(.getEnvelopeDetail)),
        sinkSpecificEnvelopePublisher()
      )

    case let .presentAlert(present):
      state.isDeleteAlertPresent = present
      return .none

    case let .tappedSpecificEnvelope(property):
      let id = property.id
      return .send(.inner(.pushEnvelopeDetail(id: id)))

    case .tappedAlertConfirmButton:
      return .send(.async(.deleteFriend))

    case let .onAppearDetail(property):
      if property == state.envelopeContents.last && !state.isEndOfPage {
        return .send(.async(.getEnvelopeDetail))
          .throttle(id: ThrottleID.requestEnvelope, for: 2, scheduler: mainQueue, latest: false)
      }
      return .none

    case .finishedCreateEnvelopes:
      return .send(.async(.updateEnvelopeInitialPage))

    case let .presentCreateEnvelope(val):
      state.isPresentCreateEnvelope = val
      state.isUpdateEnvelopePropertyAtMain = true
      return .none

    case .tappedFloatingButton:
      state.isPresentCreateEnvelope = true
      return .none
    }
  }

  enum InnerAction: Equatable, Sendable {
    case isLoading(Bool)
    case updateEnvelopeContents([EnvelopeContent])
    case overwriteEnvelopeContents([EnvelopeContent])
    case pushEnvelopeDetail(id: Int64)
    case deleteEnvelope(id: Int64)
    case updateEnvelopeProperty(EnvelopeProperty)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .isLoading(value):
      state.isLoading = value
      return .none

    case let .updateEnvelopeContents(envelopeContents):
      let prevEnvelopesCount = state.envelopeContents.count
      state.envelopeContents = (state.envelopeContents + envelopeContents).uniqued()
      if prevEnvelopesCount == state.envelopeContents.count {
        state.isEndOfPage = true
      }
      return .none

    case let .pushEnvelopeDetail(id):
      SpecificEnvelopeHistoryRouterPublisher
        .push(.specificEnvelopeHistoryDetail(.init(envelopeID: id)))
      return .none

    case let .overwriteEnvelopeContents(envelopesContent):
      state.envelopeContents.overwriteByID(envelopesContent)
      return .none

    case let .deleteEnvelope(id):
      state.envelopeContents.removeAll(where: { $0.id == id })
      return .send(.async(.updateEnvelopeProperty))

    case let .updateEnvelopeProperty(envelopeProperty):
      state.envelopeProperty = envelopeProperty
      return .none
    }
  }

  enum AsyncAction: Equatable, Sendable {
    case getEnvelopeDetail
    case deleteFriend
    case updateEnvelope(id: Int64)
    case updateEnvelopeProperty
    case updateEnvelopeInitialPage
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .getEnvelopeDetail:
      let page = state.page
      state.page += 1
      return .ssRun { [id = state.envelopeProperty.id] send in
        await send(.inner(.isLoading(true)))
        let envelopeContents = try await network.getEnvelope(.init(friendID: id, page: page))
        await send(.inner(.updateEnvelopeContents(envelopeContents)))
        await send(.inner(.isLoading(false)))
      }

    case .updateEnvelopeInitialPage:
      let page = 0
      state.page = 1
      return .ssRun { [id = state.envelopeProperty.id] send in
        await send(.inner(.isLoading(true)))
        let envelopeContents = try await network.getEnvelope(.init(friendID: id, page: page))
        await send(.inner(.updateEnvelopeContents(envelopeContents)))
        await send(.async(.updateEnvelopeProperty))
        await send(.inner(.isLoading(false)))
      }

    case .deleteFriend:
      return .ssRun { [id = state.envelopeProperty.id] _ in
        try await network.deleteFriendByID(id)
        sentUpdatePublisher.deleteEnvelopes(friendID: id)
        await dismiss()
      }

    case let .updateEnvelope(id: id):
      return .ssRun { send in
        let envelope = try await network.getEnvelopeByID(id)
        await send(.inner(.overwriteEnvelopeContents([envelope])))
        await send(.async(.updateEnvelopeProperty))
      }

    case .updateEnvelopeProperty:
      state.isUpdateEnvelopePropertyAtMain = true
      return .ssRun { [envelopeID = state.envelopeProperty.id] send in
        if let envelopeProperty = try await network.getEnvelopePropertyByID(envelopeID) {
          await send(.inner(.updateEnvelopeProperty(envelopeProperty)))
        }
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedTextButton):
      state.isDeleteAlertPresent = true
      return .none

    case .header(.tappedDismissButton):
      if state.isUpdateEnvelopePropertyAtMain {
        sentUpdatePublisher
          .editEnvelopes(friendID: state.envelopeProperty.id)
      }
      return .none

    case .header:
      return .none
    }
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.envelopeNetwork) var network
  @Dependency(\.sentUpdatePublisher) var sentUpdatePublisher
  @Dependency(\.specificEnvelopePublisher) var specificEnvelopePublisher
  @Dependency(\.mainQueue) var mainQueue

  enum DelegateAction: Equatable, Sendable {}

  enum ThrottleID: Sendable {
    case requestEnvelope
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureScopeAction, FeatureAsyncAction, FeatureInnerAction

extension SpecificEnvelopeHistoryList: FeatureViewAction, FeatureScopeAction, FeatureAsyncAction, FeatureInnerAction {
  func sinkSpecificEnvelopePublisher() -> Effect<Action> {
    .merge(
      .publisher {
        specificEnvelopePublisher
          .deleteEnvelopePublisher
          .map { id in .inner(.deleteEnvelope(id: id)) }
      },
      .publisher {
        specificEnvelopePublisher
          .updateEnvelopeIDPublisher
          .map { id in .async(.updateEnvelope(id: id)) }
      }
    )
  }
}
