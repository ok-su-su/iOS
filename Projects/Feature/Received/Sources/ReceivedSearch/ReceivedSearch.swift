//
//  ReceivedSearch.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSEnvelope
import SSRegexManager
import SSSearch
import SSToast

// MARK: - ReceivedSearch

@Reducer
struct ReceivedSearch {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false

    // Scope State
    @Shared var searchProperty: ReceivedSearchProperty
    var search: SSSearchReducer<ReceivedSearchProperty>.State
    var path: StackState<LedgerDetailPath.State> = .init()
    var header: HeaderViewFeature.State = .init(.init(type: .depth2NonIconType))
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    init() {
      _searchProperty = .init(.default)
      search = .init(helper: _searchProperty)
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {
    case push(LedgerDetailPath.State)
    case prevSearchItems
  }

  enum AsyncAction: Equatable {
    case searchLedgerByName(String?)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case search(SSSearchReducer<ReceivedSearchProperty>.Action)
    case path(StackActionOf<LedgerDetailPath>)
    case header(HeaderViewFeature.Action)
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
      return .merge(
        // Subscribe
        .publisher {
          LedgerDetailRouterPublisher
            .publisher()
            .map { .inner(.push($0)) }
        },

        // initialSearch
        .send(.inner(.prevSearchItems))
      )
    }
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case let .search(.changeTextField(text)):
      return ToastRegexManager.isShowToastByLedgerName(text) ?
        .send(.scope(.toast(.showToastMessage("경조사 명은 10글자까지만 입력 가능해요")))) : .none
    case let .search(.tappedPrevItem(id)):
      // ID Logic
      return .none

    case let .search(.tappedSearchItem(id)):
      return .none

    case .search:
      return .none

    case .path:
      return .none

    case .header:
      return .none

    case .toast:
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .push(pathState):
      state.path.append(pathState)
      return .none
    case .prevSearchItems:
      state.searchProperty.prevSearchedItem = persistence.getPrevSearchItems()
      return .none
    }
  }

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .searchLedgerByName(_):
      return .none
    }
  }

  @Dependency(\.receivedSearchPersistence) var persistence
  ///  @Dependency(\.receivedSearchPersistence) var persistence
  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.search, action: \.scope.search) {
      SSSearchReducer()
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
    .addFeatures()
  }
}

extension Reducer where Self.State == ReceivedSearch.State, Self.Action == ReceivedSearch.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.scope.path)
  }
}
