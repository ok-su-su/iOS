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
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var ssButtonProperties: [Int: SSButtonPropertyState] = [:]
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case reloadFilter
    case reset
    case header(HeaderViewFeature.Action)
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
      default:
        return .none
      }
    }
  }
}
