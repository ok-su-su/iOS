//
//  LedgerDetailFilter.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

// MARK: - LedgerDetailFilter

@Reducer
struct LedgerDetailFilter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var textFieldText: String = ""
    @Shared var property: LedgerDetailFilterProperty
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var isLoading = true
    init(_ property: Shared<LedgerDetailFilterProperty>) {
      _property = property
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
    case tappedItem(LedgerFilterItemProperty)
    case changeTextField(String)
    case closeButtonTapped
    case tappedConfirmButton(lowest: Int64, highest: Int64)
    case reset
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateItems([LedgerFilterItemProperty])
  }

  enum AsyncAction: Equatable {
    case searchInitialFriends
    case searchFriendsBy(name: String)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.dismiss) var dismiss

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.searchInitialFriends))

    case let .tappedItem(item):
      state.property.select(item.id)
      return .none

    case let .changeTextField(text):
      state.textFieldText = text
      return .none

    case .closeButtonTapped:
      return .run { _ in
        await dismiss()
      }

    case let .tappedConfirmButton(lowest, highest):
      state.property.highestAmount = highest
      state.property.lowestAmount = lowest
      return .run { _ in
        await dismiss()
      }

    case .reset:
      state.property.reset()
      return .none
    }
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header:
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateItems(items):
      let uniqueItem = (state.property.selectableItems + items).uniqued()
      state.property.selectableItems = uniqueItem
      return .none
    }
  }

  @Dependency(\.ledgerDetailFilterNetwork) var network
  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .searchInitialFriends:
      return .run { send in
        await send(.inner(.isLoading(true)))
        let items = try await network.getInitialData()
        await send(.inner(.updateItems(items)))
        await send(.inner(.isLoading(false)))
      }

    case let .searchFriendsBy(name):
      return .run { send in
        await send(.inner(.isLoading(true)))
        let items = try await network.findFriendsBy(name: name)
        await send(.inner(.updateItems(items)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> = { _, _ in
    return .none
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
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
      case let .delegate(currentAction):
        return delegateAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == LedgerDetailFilter.State, Self.Action == LedgerDetailFilter.Action {}
