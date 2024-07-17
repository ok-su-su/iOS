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
import SSRegexManager
import SSToast

@Reducer
struct CreateEnvelopeAdditionalIsGift {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isHighlight = false
    var pushable = false
    @Shared var textFieldText: String
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .send(.view(.changedTextField("")))

      case .view(.tappedNextButton):
        return .send(.inner(.push))

      case let .view(.changedTextField(newText)):
        state.textFieldText = newText
        let pushable = RegexManager.isValidGift(newText)
        state.pushable = pushable
        return ToastRegexManager.isShowToastByGift(newText) ?
          .send(.scope(.toast(.showToastMessage("선물은 30글자까지만 입력 가능해요")))) : .none

      case .view(.changeIsHighlight(_)):
        return .none

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .gift)
        CreateEnvelopeRequestShared.setGift(state.textFieldText)
        return .none

      case .scope(.toast(_)):
        return .none
      }
    }
  }
}
