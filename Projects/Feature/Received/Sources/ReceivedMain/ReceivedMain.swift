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

@Reducer
public struct ReceivedMain {
  @ObservableState
  public struct State {
    var isLoading: Bool = false
    var headerType = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabbarType = SSTabBarFeature.State(tabbarType: .received)

    @Presents var searchInvenotry: InventorySearch.State?
    @Presents var sortSheet: InventorySortSheet.State?
    @Presents var inventoryAccount: InventoryAccountDetailRouter.State?
    @Shared var searchInventoryHelper: InventorySearchHelper
    @Shared var selectedSortItem: SortTypes

    init() {
      _searchInventoryHelper = Shared(.init())
      _selectedSortItem = Shared(.latest)
    }
  }

  public init() {}

  @CasePathable
  public enum Action: FeatureAction {
    case setHeaderView(HeaderViewFeature.Action)
    case setTabbarView(SSTabBarFeature.Action)
    case setFloatingView(InventoryFloating.Action)
    case showSearchView(PresentationAction<InventorySearch.Action>)

    case sortSheet(PresentationAction<InventorySortSheet.Action>)
    case showInventoryDetailView(PresentationAction<InventoryAccountDetailRouter.Action>)
    case didTapInventoryView
    case didTapLatestButton
    case didTapFilterButton
    case didTapAddInventoryButton
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: /Action.setHeaderView) {
      HeaderViewFeature()
    }

    Scope(state: \.tabbarType, action: /Action.setTabbarView) {
      SSTabBarFeature()
    }

    Scope(state: \.floatingState, action: /Action.setFloatingView) {
      InventoryFloating()
    }

    .ifLet(\.$searchInvenotry, action: \.showSearchView) {
      InventorySearch()
    }

    .ifLet(\.$sortSheet, action: \.sortSheet) {
      InventorySortSheet()
    }

    .ifLet(\.$inventoryAccount, action: \.showInventoryDetailView) {
      InventoryAccountDetailRouter()
    }

    Reduce { state, action in
      switch action {
      case .reloadInvetoryItems:
        state.isLoading.toggle()
        return .none
      case .didTapLatestButton:
        state.sortSheet = InventorySortSheet.State(selectedSortItem: state.$selectedSortItem)
        return .none
      case .setHeaderView(.tappedSearchButton):
        state.searchInvenotry = InventorySearch.State(searchHelper: state.$searchInventoryHelper)
        return .none
      case .didTapFilterButton:
        return .none
      case .didTapInventoryView:
        state.inventoryAccount = InventoryAccountDetailRouter.State()
        return .none
      case .didTapAddInventoryButton:
        return .none
      default:
        return .none
      }
    }
  }
}
