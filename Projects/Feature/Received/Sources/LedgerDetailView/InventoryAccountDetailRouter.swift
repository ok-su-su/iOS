//
//  InventoryAccountDetailRouter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

// MARK: - InventoryAccountDetailRouter

@Reducer
public struct InventoryAccountDetailRouter {
  @ObservableState
  public struct State {
    var path: StackState<Path.State> = .init()
    var isAppear = false
  }

  public enum Action {
    case path(StackActionOf<Path>)
    case onAppear(Bool)
  }

  @Reducer
  public enum Path {
    case showInventoryAccountDetail(InventoryAccountDetail)
    case showInventoryAccountFilter(InventoryAccountDetailFilter)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .path(action):
        switch action {
        case .element(id: _, action: .showInventoryAccountDetail):
          return .none
        case .element(id: _, action: .showInventoryAccountFilter):
          return .none
        default:
          return .none
        }
      case .onAppear(true):
        state.path.append(.showInventoryAccountDetail(InventoryAccountDetail.State(accountProperty: .init(price: "100000", category: .Wedding, accountTitle: "고모부 장례", date: .now, accountList: []))))
        return .none
      default:
        return .none
      }
    }.forEach(\.path, action: \.path)
  }
}
