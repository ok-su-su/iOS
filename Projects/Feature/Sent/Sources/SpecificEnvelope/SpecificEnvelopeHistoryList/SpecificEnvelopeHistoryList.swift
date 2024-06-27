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

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateEnvelopeContents([EnvelopeContent])
    case pushEnvelopeDetail(EnvelopeDetailProperty)
    case updateEnvelopeDetailIfUserDeleteEnvelope
  }

  enum AsyncAction: Equatable {
    case getEnvelopeDetail
    case deleteFriend
    case getEnvelopeDetailByID(Int64)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case envelopePriceProgress(EnvelopePriceProgress.Action)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.envelopeNetwork) var network

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
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .send(.inner(.updateEnvelopeDetailIfUserDeleteEnvelope))
        }
        state.isOnAppear = isAppear
        return .send(.async(.getEnvelopeDetail))

      case .scope(.header(.tappedTextButton)):
        state.isDeleteAlertPresent = true
        return .none

      case .scope(.header):
        return .none

      // envelope Detail 화면으로 이동
      case let .view(.tappedSpecificEnvelope(property)):
        let id = property.id
        return .send(.async(.getEnvelopeDetailByID(id)))

      case .scope(.envelopePriceProgress):
        return .none

      // 친구 삭제를 누를 경우
      case .view(.tappedAlertConfirmButton):
        return .send(.async(.deleteFriend))

      case .async(.getEnvelopeDetail):
        let page = state.page
        state.page += 1
        return .run { [id = state.envelopeProperty.id] send in
          await send(.inner(.isLoading(true)))
          let envelopeContents = try await network.getEnvelope(friendID: id, page: page)
          await send(.inner(.updateEnvelopeContents(envelopeContents)))
          await send(.inner(.isLoading(false)))
        }
      case let .inner(.isLoading(value)):
        state.isLoading = value
        return .none

      case let .inner(.updateEnvelopeContents(envelopeContents)):
        let prevEnvelopesCount = state.envelopeContents.count
        state.envelopeContents = (state.envelopeContents + envelopeContents).uniqued()
        if prevEnvelopesCount == state.envelopeContents.count {
          state.isEndOfPage = true
        }
        return .none

      case .async(.deleteFriend):
        return .run { [id = state.envelopeProperty.id] _ in
          try await network.deleteFriend(id: id)
          await dismiss()
        }

      case let .view(.presentAlert(present)):
        state.isDeleteAlertPresent = present
        return .none

      case let .async(.getEnvelopeDetailByID(id)):
        return .run { send in
          let envelopeDetailProperty = try await network.getEnvelopeDetailPropertyByEnvelope(id: id)
          await send(.inner(.pushEnvelopeDetail(envelopeDetailProperty)))
        }

      case let .inner(.pushEnvelopeDetail(property)):
        SpecificEnvelopeHistoryRouterPublisher
          .push(.specificEnvelopeHistoryDetail(.init(envelopeDetailProperty: property)))
        return .none

      case let .view(.onAppearDetail(property)):
        if property == state.envelopeContents.last && !state.isEndOfPage {
          return .send(.async(.getEnvelopeDetail))
            .throttle(id: ThrottleID.requestEnvelope, for: 2, scheduler: RunLoop.main, latest: false)
        }
        return .none
      case .inner(.updateEnvelopeDetailIfUserDeleteEnvelope):
        if let id = SpecificEnvelopeSharedState.shared.getDeletedEnvelopeID() {
          state.envelopeContents.removeAll(where: { $0.id == id })
        }
        return .none
      }
    }
  }
}
