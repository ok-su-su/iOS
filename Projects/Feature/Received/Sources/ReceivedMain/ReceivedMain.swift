//
//  ReceivedMain.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSBottomSelectSheet

// MARK: - ReceivedMain

@Reducer
struct ReceivedMain {
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = true
    var isOnAppear: Bool = false
    var page = 0
    var isEndOfPage = false

    /// ScopeState
    var header = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabBar = SSTabBarFeature.State(tabbarType: .received)
    @Shared var sortProperty: SortHelperProperty
    @Shared var filterProperty: FilterHelperProperty
    @Presents var search: ReceivedSearch.State?
    @Presents var sort: SSSelectableBottomSheetReducer<SortDialItem>.State?

    var ledgersProperty: [LedgerBoxProperty] = []

    var isFilteredHeaderButtonItem: Bool {
      return true
    }

    init() {
      _sortProperty = .init(.init())
      _filterProperty = .init(.init())
    }
  }

  public init() {}

  @Dependency(\.receivedMainNetwork) var network

  @CasePathable
  enum Action: FeatureAction, Equatable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case tappedAddLedgerButton
    case tappedFilterButton
    case tappedFilteredAmountButton
    case tappedFilteredPersonButton(id: Int64)
    case onAppear(Bool)
    case onAppearedLedger(LedgerBoxProperty)
    case tappedSortButton
    case tappedFloatingButton
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateLedgers([LedgerBoxProperty])
  }

  enum AsyncAction: Equatable {
    case getLedgersInitialPage
    case getLedgers
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case sortSheet(PresentationAction<InventorySortSheet.Action>)
    case search(PresentationAction<ReceivedSearch.Action>)
    case sort(PresentationAction<SSSelectableBottomSheetReducer<SortDialItem>.Action>)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getLedgersInitialPage))

    case .tappedAddLedgerButton:
      return .none

    case .tappedFilteredAmountButton:
      state.filterProperty.resetDate()
      return .none

    case .tappedFilterButton:
      return .none

    case let .tappedFilteredPersonButton(id: id):
      state.filterProperty.deleteSelectedItem(id: id)
      return .none

    case .tappedSortButton:
      state.sort = .init(items: state.sortProperty.defaultItems, selectedItem: state.$sortProperty.selectedFilterDial)
      return .none
    case .tappedFloatingButton:
      // create ledger 주입
      return .none

    case let .onAppearedLedger(property):
      if state.ledgersProperty.last?.id == property.id {
        return .send(.async(.getLedgers))
      }
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { state, action in
    switch action {
    case .header(.tappedSearchButton):
      state.search = .init()
      return .none
    case .header:
      return .none
    case .tabBar:
      return .none
    case .sortSheet(.dismiss):
      return .send(.async(.getLedgersInitialPage))
    case .sortSheet:
      return .none
    case .search:
      return .none
    case .sort:
      return .none
    }
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { state, action in
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateLedgers(val):
      let prevCount = state.ledgersProperty.count
      let currentProperty = (state.ledgersProperty + val).uniqued()
      if prevCount == currentProperty.count {
        state.isEndOfPage = true
      }
      state.page += 1
      state.ledgersProperty = currentProperty
      return .none
    }
  }

  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getLedgersInitialPage:
      state.ledgersProperty = []
      let sortType = state.sortProperty.selectedFilterDial ?? .latest
      state.page = 0
      // TODO: 각자 맞게 수정해야함 파라미터들
      let param = SearchLedgersRequestParameter(title: nil, fromStartAt: nil, toStartAt: nil, toEndAt: nil, page: 0, sort: sortType)
      return .run { send in
        await send(.inner(.isLoading(true)))
        let property = try await network.getLedgers(param)
        await send(.inner(.updateLedgers(property)))
        await send(.inner(.isLoading(false)))
      }

    case .getLedgers:
      if state.isEndOfPage {
        return .none
      }
      let currentPage = state.page
      let sortType = state.sortProperty.selectedFilterDial ?? .latest
      // TODO: 각자 맞게 수정해야함 파라미터들
      let param = SearchLedgersRequestParameter(title: nil, fromStartAt: nil, toStartAt: nil, toEndAt: nil, page: currentPage, sort: sortType)
      return .run { send in
        await send(.inner(.isLoading(true)))
        let property = try await network.getLedgers(param)
        await send(.inner(.updateLedgers(property)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == ReceivedMain.State, Action == ReceivedMain.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$search, action: \.scope.search) {
      ReceivedSearch()
    }
    .ifLet(\.$sort, action: \.scope.sort) {
      SSSelectableBottomSheetReducer()
    }
  }
}
