//
//  InventorySortSheet.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

// MARK: - SortTypes

public enum SortTypes: String, CaseIterable {
  case latest = "최신순"
  case oldest = "오래된순"
  case highestPrice = "금액 높은 순"
  case lowestPrice = "금액 낮은 순"
}

// MARK: - InventorySortSheet

@Reducer
public struct InventorySortSheet {
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  public struct State {
    var sortItems: SortTypes.AllCases = [.latest, .oldest, .highestPrice, .lowestPrice]
    @Shared var selectedSortItem: SortTypes
  }

  public enum Action: Equatable {
    case didTapSortItem(SortTypes)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .didTapSortItem(type):
        state.selectedSortItem = type
        return .none
      }
    }
  }
}
