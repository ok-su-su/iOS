//
//  CreateEnvelopeAdditionalIsGift.swift
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
struct CreateEnvelopeAdditionalIsGift {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isHighlight = false
    @Shared var textFieldText: String
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

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
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }

    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case let .view(.changedTextField(newText)):
        state.textFieldText = newText
        let pushable = newText.count < 30 && !newText.isEmpty
        let isToastShow = newText.count > 30
        return .run { send in
          if isToastShow {
            await send(.scope(.toast(.showToastMessage("선물은 30글자까지만 입력 가능해요"))))
          }
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }

      case .view(.changeIsHighlight(_)):
        return .none
      case .scope(.nextButton(.view(.tappedNextButton))):
        return .send(.inner(.push))

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .gift)
        CreateEnvelopeRequestShared.setGift(state.textFieldText)
        return .none
      case .scope(.nextButton(.delegate)):
        return .none

      case .scope(.nextButton):
        return .none

      case .scope(.toast(_)):
        return .none
      }
    }
  }
}
