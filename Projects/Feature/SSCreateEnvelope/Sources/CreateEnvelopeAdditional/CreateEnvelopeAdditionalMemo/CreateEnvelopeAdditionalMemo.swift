//
//  CreateEnvelopeAdditonalMemo.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSToast

@Reducer
struct CreateEnvelopeAdditionalMemo {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var memoHelper: CreateEnvelopeAdditionalMemoHelper

    var nextButton: CreateEnvelopeBottomOfNextButton.State = .init()
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none, duration: 1))

    init(memoHelper: Shared<CreateEnvelopeAdditionalMemoHelper>) {
      _memoHelper = memoHelper
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
    case textFieldChange(String)
    case isHighlightChanged(Bool)
  }

  enum InnerAction: Equatable {
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .inner(.push):
        CreateEnvelopeRequestShared.setMemo(state.memoHelper.textFieldText)
        CreateAdditionalRouterPublisher.shared.push(from: .memo)
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .send(.inner(.push))

      case .scope(.nextButton):
        return .none

      case let .view(.textFieldChange(text)):
        state.memoHelper.textFieldText = text
        let pushable = text.count < 30 && !text.isEmpty
        let isShowToastMessage = text.count > 30
        return .run { send in
          if isShowToastMessage {
            await send(.scope(.toast(.showToastMessage("메모는 30글자까지만 입력 가능해요"))))
          }
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }

      case let .view(.isHighlightChanged(highlight)):
        state.memoHelper.isHighlight = highlight
        return .none
      case .scope(.toast):
        return .none
      }
    }
  }
}
