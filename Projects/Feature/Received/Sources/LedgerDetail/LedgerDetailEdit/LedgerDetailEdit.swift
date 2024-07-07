//
//  LedgerDetailEdit.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSEditSingleSelectButton

// MARK: - LedgerDetailEdit

@Reducer
struct LedgerDetailEdit: FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .defaultNonIconType))
    var ledgerProperty: LedgerDetailProperty
    @Shared var editProperty: LedgerDetailEditProperty
    var categorySection: SingleSelectButtonReducer<CategoryEditProperty>.State
    init(ledgerProperty: LedgerDetailProperty, ledgerDetailEditProperty: LedgerDetailEditProperty) {
      self.ledgerProperty = ledgerProperty
      _editProperty = .init(ledgerDetailEditProperty)
      categorySection = .init(singleSelectButtonHelper: _editProperty.categoryEditProperty)
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
    case changeNameTextField(String)
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    case let .changeNameTextField(name):
      state.editProperty.changeNameTextField(name)
      return .none
    }
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case categorySection(SingleSelectButtonReducer<CategoryEditProperty>.Action)
  }

  enum DelegateAction: Equatable {}

  func asyncAction(_: inout State, _: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    return .none
  }

  func innerAction(_: inout State, _: InnerAction) -> ComposableArchitecture.Effect<Action> {
    return .none
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none
    case .categorySection:
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.categorySection, action: \.scope.categorySection) {
      SingleSelectButtonReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == LedgerDetailEdit.State, Self.Action == LedgerDetailEdit.Action {}
