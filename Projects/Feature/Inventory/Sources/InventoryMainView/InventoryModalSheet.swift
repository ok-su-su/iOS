//
//  InventoryModalSheet.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryModalSheet

@Reducer
struct InventoryModalSheet {
  @ObservableState
  struct State {
    var initialStartDate = Date.now
    var initialEndDate = Calendar.current.date(byAdding: .year, value: 4, to: .now)!

    @Shared var startDate: Date?
    @Shared var endDate: Date?
    @Shared var selectedFilter: InventoryType.AllCases
    @Shared var selectedFilterProperties: [Int: SSButtonPropertyState]

    init(startDate: Shared<Date?>, endDate: Shared<Date?>, selectedFilter: Shared<InventoryType.AllCases>, selectedFilterProperties: Shared<[Int: SSButtonPropertyState]>) {
      _startDate = startDate
      _endDate = endDate
      _selectedFilter = selectedFilter
      _selectedFilterProperties = selectedFilterProperties
    }
  }

  enum Action: Equatable {
    case didSelectedStartDate(date: Date)
    case reset
    case didTapConfirmButton
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .didSelectedStartDate(date):
        if state.startDate == nil {
          state.endDate = date
        } else {
          state.startDate = date
        }
        return .none

      case .reset:
        state.startDate = .now
        state.endDate = .now

        for resetInventory in state.selectedFilter {
          state.selectedFilterProperties[resetInventory.rawValue] = .init(
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
      }
    }
  }
}
