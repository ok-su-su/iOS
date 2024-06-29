//
//  InventoryRouter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

// MARK: - InventoryRouter

@Reducer
struct InventoryRouter {
  @ObservableState
  struct State {
    var path = StackState<Path.State>()
    var isAppear = false
  }

  enum Action {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .path(action):
        switch action {
        case .element(id: _, action: .inventoryItem):
          return .none
        case .element(id: _, action: .inventoryFilterItem):
          return .none
        default:
          return .none
        }
      case .onAppear(true):
        state.path.append(.inventoryItem(ReceivedMain.State()))
        return .none
      case .onAppear(false):
        return .none
      }
    }.forEach(\.path, action: \.path)
  }
}

// MARK: InventoryRouter.Path

extension InventoryRouter {
  @Reducer
  enum Path {
    case inventoryItem(ReceivedMain)
    case inventoryFilterItem(InventoryFilter)
  }
}
