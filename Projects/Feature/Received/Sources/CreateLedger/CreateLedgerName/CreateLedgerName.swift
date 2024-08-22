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
import SSRegexManager
import SSToast

// MARK: - CreateLedgerName

@Reducer
struct CreateLedgerName {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var textFieldText: String = ""
    var isFocused = false
    var pushable = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    init() {}
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
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case let .changedTextField(text):
      state.textFieldText = text
      state.pushable = RegexManager.isValidCustomCategory(text)

      return ToastRegexManager.isShowToastByCustomCategory(text) ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.category.message)))) : .none
    case .tappedNextButton:
      CreateLedgerSharedState.setTitle(state.textFieldText)
      CreateLedgerRouterPathPublisher.push(.date(.init()))
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { _, _ in
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
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == CreateLedgerName.State, Self.Action == CreateLedgerName.Action {}
