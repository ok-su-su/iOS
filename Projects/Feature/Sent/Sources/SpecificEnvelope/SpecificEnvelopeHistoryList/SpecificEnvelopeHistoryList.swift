//
//  SpecificEnvelopeHistoryList.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSAlert
import SSNotification

// MARK: - SpecificEnvelopeHistoryList

@Reducer
struct SpecificEnvelopeHistoryList {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var envelopePriceProgress: EnvelopePriceProgress.State
    var isDeleteAlertPresent = false
    var header: HeaderViewFeature.State
    var envelopeProperty: EnvelopeProperty
    var envelopeContents: [EnvelopeContent] = []
    var isLoading: Bool = false
    var page = 0
    var isEndOfPage: Bool = false

    init(envelopeProperty: EnvelopeProperty) {
      self.envelopeProperty = envelopeProperty
      header = .init(.init(title: envelopeProperty.envelopeTargetUserNameText, type: .depth2Text("삭제")))
      envelopePriceProgress = .init(
        envelopePriceProgressProperty: .init(
          leadingPriceValue: envelopeProperty.totalSentPrice,
          trailingPriceValue: envelopeProperty.totalReceivedPrice
        )
      )
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case presentAlert(Bool)
    case tappedSpecificEnvelope(EnvelopeContent)
    case tappedAlertConfirmButton
    case onAppearDetail(EnvelopeContent)
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
          .throttle(id: ThrottleID.requestEnvelope, for: 2, scheduler: RunLoop.main, latest: false)
      }
      return .none
    }
  }

  enum InnerAction: Equatable {
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
      envelopesContent.forEach { envelopeContent in
        if let index = state.envelopeContents.firstIndex(where: { $0.id == envelopeContent.id }) {
          state.envelopeContents[index] = envelopeContent
        }
      }
      return .none

    case let .deleteEnvelope(id):
      state.envelopeContents.removeAll(where: { $0.id == id })
      return .send(.async(.updateEnvelopeProperty))

    case let .updateEnvelopeProperty(envelopeProperty):
      state.envelopeProperty = envelopeProperty
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getEnvelopeDetail
    case deleteFriend
    case updateEnvelope(id: Int64)
    case updateEnvelopeProperty
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .getEnvelopeDetail:
      let page = state.page
      state.page += 1
      return .run { [id = state.envelopeProperty.id] send in
        await send(.inner(.isLoading(true)))
        let envelopeContents = try await network.getEnvelope(friendID: id, page: page)
        await send(.inner(.updateEnvelopeContents(envelopeContents)))
        await send(.inner(.isLoading(false)))
      }

    case .deleteFriend:
      return .run { [id = state.envelopeProperty.id] _ in
        try await network.deleteFriend(id: id)
        sentUpdatePublisher.deleteEnvelopes(friendID: id)
        await dismiss()
      }

    case let .updateEnvelope(id: id):
      return .run { [] send in
        let envelope = try await network.getEnvelope(envelopeID: id)
        await send(.inner(.overwriteEnvelopeContents([envelope])))
        await send(.async(.updateEnvelopeProperty))
      }

    case .updateEnvelopeProperty:
      return .run { [envelopeID = state.envelopeProperty.id] send in
        if let envelopeProperty = try await network.getEnvelopeProperty(ID: envelopeID) {
          await send(.inner(.updateEnvelopeProperty(envelopeProperty)))
        }
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case envelopePriceProgress(EnvelopePriceProgress.Action)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedTextButton):
      state.isDeleteAlertPresent = true
      return .none

    case .header:
      return .none

    case .envelopePriceProgress:
      return .none
    }
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.envelopeNetwork) var network
  @Dependency(\.sentUpdatePublisher) var sentUpdatePublisher
  @Dependency(\.specificEnvelopePublisher) var specificEnvelopePublisher

  enum DelegateAction: Equatable {}

  enum ThrottleID {
    case requestEnvelope
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.envelopePriceProgress, action: \.scope.envelopePriceProgress) {
      EnvelopePriceProgress()
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
          .subscribe(on: RunLoop.main)
          .map { id in .inner(.deleteEnvelope(id: id)) }
      },
      .publisher {
        specificEnvelopePublisher
          .updateEnvelopeIDPublisher
          .subscribe(on: RunLoop.main)
          .map { id in .async(.updateEnvelope(id: id)) }
      }
    )
  }
}
