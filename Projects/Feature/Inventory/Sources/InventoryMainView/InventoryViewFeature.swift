//
//  InventoryViewFeature.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

@Reducer
public struct InventoryViewFeature {
  public init() {}

  @ObservableState
  public struct State {
    var inventorys: IdentifiedArrayOf<InventoryBox.State> = [
      .init(inventoryType: .Wedding, inventoryTitle: "나의 결혼식", inventoryAmount: "4,388,000", inventoryCount: 164),
    ]
    var isLoading: Bool = false
    var headerType = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabbarType = SSTabBarFeature.State(tabbarType: .inventory)

    @Presents var searchInvenotry: InventorySearch.State?
    @Presents var sortSheet: InventorySortSheet.State?
    @Presents var inventoryAccount: InventoryAccountDetailRouter.State?

    @Shared var selectedSortItem: SortTypes

    init() {
      _selectedSortItem = Shared(.latest)
    }
  }

  @CasePathable
  public enum Action {
    case setHeaderView(HeaderViewFeature.Action)
    case setTabbarView(SSTabBarFeature.Action)
    case setFloatingView(InventoryFloating.Action)
    case reloadInvetoryItems(IdentifiedActionOf<InventoryBox>)
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
    }.forEach(\.inventorys, action: \.reloadInvetoryItems) {
      InventoryBox()
    }
  }
}
