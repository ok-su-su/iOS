// 
//  CreateLedgerName.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSToast


@Reducer
struct CreateLedgerName {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var textFieldText: String = ""
    var isFocused = false
    var pushable = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    init () {}
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear) :
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    case let .changedTextField(text):
      state.textFieldText = text
      state.pushable = TextValidator.checkCategoryName(text)

      return .run { send in
        if TextValidator.checkCategoryNameWithToast(text) {
          await send(.scope(.toast(.showToastMessage("경조사 이름 10글자까지만 입력 가능해요"))))
        }
      }
    case .tappedNextButton:
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { state, action in
    return .none
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { state, action in
    return .none
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .scope(currentAction) :
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == CreateLedgerName.State, Self.Action == CreateLedgerName.Action { }
