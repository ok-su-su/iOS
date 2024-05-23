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
    @Presents var sheet: InventoryDatePickerModalSheet.State?
    var previousDate: Date = .now
    var nextDate: Date = .now
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var ssSelectedButtonProperties: [Int: SSButtonPropertyState] = [:]
    @Shared var startDate: Date?
    @Shared var endDate: Date?
    @Shared var selectedFilter: InventoryType.AllCases
    @Shared var ssButtonProperties: [Int: SSButtonPropertyState]
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case reloadFilter
    case reset
    case sheet(PresentationAction<InventoryDatePickerModalSheet.Action>)
    case header(HeaderViewFeature.Action)
    case didTapFilterButton(Int)
    case didShowStartDateFilterView
    case didShowEndDateFilterView
    case didTapSelectedFilterButton(Int)
    case didTapConfirmButton
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }

    .ifLet(\.$sheet, action: \.sheet) {
      InventoryDatePickerModalSheet()
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

      case .didShowStartDateFilterView:
        state.sheet = InventoryDatePickerModalSheet.State(startDate: state.$startDate, endDate: Shared(nil), selectedFilter: state.$selectedFilter, selectedFilterProperties: state.$ssButtonProperties)
        return .none
      case .didShowEndDateFilterView:
        state.sheet = InventoryDatePickerModalSheet.State(startDate: Shared(nil), endDate: state.$endDate, selectedFilter: state.$selectedFilter, selectedFilterProperties: state.$ssButtonProperties)
        return .none
      case .reset:
        state.startDate = .now
        state.endDate = .now

        for resetInventory in state.selectedFilter {
          state.ssButtonProperties[resetInventory.rawValue] = .init(
            size: .xsh28,
            status: .inactive,
            style: .lined,
            color: .black,
            buttonText: resetInventory.type
          )
        }
        state.selectedFilter.removeAll()
        return .none
      case .didTapConfirmButton:
        return .run { _ in await dismiss() }
      default:
        return .none
      }
    }
  }
}
