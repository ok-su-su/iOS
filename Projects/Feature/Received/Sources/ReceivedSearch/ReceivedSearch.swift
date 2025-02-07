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
struct ReceivedSearch: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
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

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable, Sendable {
    case push(LedgerDetailPath.State)
    case prevSearchItems
    case updateSearchItems([ReceivedSearchItem])
  }

  enum AsyncAction: Equatable, Sendable {
    case searchLedgerByName(String)
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case search(SSSearchReducer<ReceivedSearchProperty>.Action)
    case path(StackActionOf<LedgerDetailPath>)
    case header(HeaderViewFeature.Action)
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable, Sendable {}

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
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

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case let .search(.changeTextField(text)):
      return .concatenate(
        ToastRegexManager.isShowToastByLedgerName(text) ?
          .send(.scope(.toast(.showToastMessage(DefaultToastMessage.ledger.message)))) : .none,

        .send(.async(.searchLedgerByName(text)))
      )
    case let .search(.tappedPrevItem(id)):
      let ledgerMainState = LedgerDetailMain.State(ledgerID: id)
      state.path.append(.main(ledgerMainState))
      return .none

    case let .search(.tappedSearchItem(id)):
      let ledgerMainState = LedgerDetailMain.State(ledgerID: id)
      persistence.setSearchItems(state.searchProperty.nowSearchedItem.first(where: { $0.id == id }))
      state.path.append(.main(ledgerMainState))
      return .send(.inner(.prevSearchItems)) // UpdatePrevSearch

    case let .search(.tappedDeletePrevItem(id)):
      persistence.deleteItem(id: id)
      return .send(.inner(.prevSearchItems))

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

    case let .updateSearchItems(items):
      state.searchProperty.nowSearchedItem = items
      return .none
    }
  }

  enum NetworkCancelID {
    case searchLedger
  }

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case let .searchLedgerByName(name):
      return .ssRun { send in
        let items = try await network.searchLedgersByName(name)
        await send(.inner(.updateSearchItems(items)))
      }
      .cancellable(id: NetworkCancelID.searchLedger, cancelInFlight: true)
    }
  }

  @Dependency(\.receivedSearchPersistence) var persistence
  @Dependency(\.receivedSearchNetwork) var network
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
