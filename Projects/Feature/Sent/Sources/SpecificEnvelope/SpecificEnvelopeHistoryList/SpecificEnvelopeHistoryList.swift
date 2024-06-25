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

  enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedSpecificEnvelope(EnvelopeContent)
    case tappedAlertConfirmButton
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateEnvelopeContents([EnvelopeContent])
  }

  enum AsyncAction: Equatable {
    case getEnvelopeDetail(page: Int)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case envelopePriceProgress(EnvelopePriceProgress.Action)
  }

  @Dependency(\.envelopeNetwork) var network

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.envelopePriceProgress, action: \.scope.envelopePriceProgress) {
      EnvelopePriceProgress()
    }

    BindingReducer()

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .send(.async(.getEnvelopeDetail(page: 0)))

      case .scope(.header(.tappedTextButton)):
        state.isDeleteAlertPresent = true
        return .none

      case .scope(.header):
        return .none

      case let .view(.tappedSpecificEnvelope(property)):
        // TODO: 화면 전환 로직
        return .none

      case .scope(.envelopePriceProgress):
        return .none

      case .binding:
        return .none
      // TODO: 만약 삭제 버튼을 눌렀다면 해야할 동작에 대해서 정의
      case .view(.tappedAlertConfirmButton):
        return .none
      case let .async(.getEnvelopeDetail(page: page)):
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
        state.envelopeContents = envelopeContents
        return .none
      }
    }
  }
}
