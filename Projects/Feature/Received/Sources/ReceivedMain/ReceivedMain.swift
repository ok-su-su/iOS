//
//  ReceivedMain.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem
import FeatureAction
import SSBottomSelectSheet

// MARK: - ReceivedMain

@Reducer
struct ReceivedMain {
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = false
    var isOnAppear: Bool = false

    /// ScopeState
    var header = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabBar = SSTabBarFeature.State(tabbarType: .received)
    @Shared var sortProperty: SortHelperProperty
    @Shared var filterProperty: FilterHelperProperty
    @Presents var search: ReceivedSearch.State?
    @Presents var sort: SSSelectableBottomSheetReducer<SortDialItem>.State?

    var ledgersProperty: [LedgerBoxProperty] = [
      .init(id: 1, categoryName: "장례식", style: "orange60", isMiscCategory: false, categoryDescription: "나의 두번 쨰 장례식", totalAmount: 50000, envelopesCount: 164),
      .init(id: 2, categoryName: "결혼식", style: "gray30", isMiscCategory: false, categoryDescription: "나의 두번 쨰 장례식", totalAmount: 1_500_000, envelopesCount: 164),
    ]

    var isFilteredHeaderButtonItem: Bool {
      return true
    }

    init() {
      _sortProperty = .init(.init())
      _filterProperty = .init(.init())
    }
  }

  public init() {}

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
    case tappedSortButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

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
      return .none

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
    case .sortSheet:
      return .none
    case .search:
      return .none
    case .sort:
      return .none
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
