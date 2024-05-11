//
//  CreateEnvelopeAdditonalMemo.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeAdditionalMemo {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var memoHelper: CreateEnvelopeAdditionalMemoHelper

    var nextButton: CreateEnvelopeBottomOfNextButton.State = .init()

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

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
  }

  enum DelegateAction: Equatable {
    case push
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .delegate(.push):
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .send(.delegate(.push))

      case .scope(.nextButton):
        return .none

      case let .view(.textFieldChange(text)):
        let pushable = text != ""
        return .send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))

      case let .view(.isHighlightChanged(highlight)):
        state.memoHelper.isHighlight = highlight
        return .none
      }
    }
  }
}
