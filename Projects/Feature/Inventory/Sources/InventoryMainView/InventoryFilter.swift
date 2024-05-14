//
//  InventoryFilter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryFilter

@Reducer
struct InventoryFilter {
  @ObservableState
  struct State {
    var isAppear = false
    var inventoryFilter: InventoryType.AllCases = []
    var selectedFilter: InventoryType.AllCases = []
    var previousDate: Date = .now
    var showSheetView: Bool = false
    var nextDate: Date = .now
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var ssButtonProperties: [Int: SSButtonPropertyState] = [:]
    var ssSelectedButtonProperties: [Int: SSButtonPropertyState] = [:]
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case reloadFilter
    case reset
    case header(HeaderViewFeature.Action)
    case didTapFilterButton(Int)
    case didShowFilterView
    case didTapSelectedFilterButton(Int)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isAppear = isAppear
        return .none

      case .reloadFilter:
        state.inventoryFilter = [
          .Wedding,
          .FirstBirthdayDay,
          .Funeral,
          .Birthday,
        ]

        for inventory in state.inventoryFilter {
          state.ssButtonProperties[inventory.rawValue] = .init(
            size: .xsh28,
            status: .inactive,
            style: .lined,
            color: .black,
            buttonText: inventory.type
          )
        }

        return .none

      case let .didTapFilterButton(index):

        if let idx = state.selectedFilter.firstIndex(of: state.inventoryFilter[index]) {
          state.ssButtonProperties[index]?.toggleStatus()
          state.selectedFilter.remove(at: idx)
        } else {
          state.ssButtonProperties[index]?.toggleStatus()
          state.selectedFilter.append(state.inventoryFilter[index])
        }

        for selectedInventory in state.selectedFilter {
          state.ssSelectedButtonProperties[selectedInventory.rawValue] = .init(
            size: .xsh28,
            status: .inactive,
            style: .filled,
            color: .orange,
            buttonText: selectedInventory.type
          )
        }

        return .none

      case .didShowFilterView:
        state.showSheetView = true
        return .none
      default:
        return .none
      }
    }
  }
}
