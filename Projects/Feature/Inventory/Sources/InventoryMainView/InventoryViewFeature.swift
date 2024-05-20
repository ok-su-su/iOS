//
//  InventoryViewFeature.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
public struct InventoryViewFeature {
  public init() {}

  @ObservableState
  public struct State {
    var inventorys: IdentifiedArrayOf<InventoryBox.State> = []
    var isLoading: Bool = false
    var headerType = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabbarType = SSTabBarFeature.State(tabbarType: .inventory)

    @Presents var sortSheet: InventorySortSheet.State?
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
      case .didTapAddInventoryButton:
        os_log("Inventory button Tap")
        return .none
      default:
        return .none
      }
    }.forEach(\.inventorys, action: \.reloadInvetoryItems) {
      InventoryBox()
    }
  }
}
