//
//  SpecificEnvelopeHistoryList.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog
import SSAlert

@Reducer
struct SpecificEnvelopeHistoryList {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var envelopePriceProgress: EnvelopePriceProgress.State = .init(envelopePriceProgressProperty: .makeFakeData())
    var isDeleteAlertPresent = false
    /// Some Logic
    var header: HeaderViewFeature.State = .init(.init(title: "김철수", type: .depth2Text("삭제")))
    @Shared var envelopeHistoryProperty: SpecificEnvelopeHistoryListProperty

    init(envelopeHistoryHelper: Shared<SpecificEnvelopeHistoryListProperty>) {
      _envelopeHistoryProperty = envelopeHistoryHelper
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
    case tappedEnvelope(UUID)
    case tappedAlertConfirmButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case envelopePriceProgress(EnvelopePriceProgress.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.envelopePriceProgress, action: \.scope.envelopePriceProgress) {
      EnvelopePriceProgress()
    }

    BindingReducer()

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.header(.tappedTextButton)):
        state.isDeleteAlertPresent = true
        return .none

      case .scope(.header):
        return .none

      case let .view(.tappedEnvelope(id)):
        os_log("id = \(id)")
        return .none

      case .scope(.envelopePriceProgress):
        return .none

      case .binding:
        return .none
      // TODO: 만약 삭제 버튼을 눌렀다면 해야할 동작에 대해서 정의
      case .view(.tappedAlertConfirmButton):
        return .none
      }
    }
  }
}

