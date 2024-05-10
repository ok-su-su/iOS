//
//  CreateEnvelopeAdditionalIsGift.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeAdditionalIsGift {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isHighlight = false
    @Shared var textFieldText: String
    var nextButton = CreateEnvelopeBottomOfNextButton.State()

    init(textFieldText: Shared<String>) {
      _textFieldText = textFieldText
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
    case changedTextField(String)
    case changeIsHighlight(Bool)
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
      case let .view(.changedTextField(newText)):
        state.textFieldText = newText
        let pushable = newText != ""
        return .send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
      case .view(.changeIsHighlight(_)):
        return .none
      case .scope(.nextButton(.view(.tappedNextButton))):
        return .send(.delegate(.push))
      case .delegate:
        return .none
      case .scope(.nextButton(.delegate)):
        return .none
      case .scope(.nextButton):
        return .none
      }
    }
  }
}
