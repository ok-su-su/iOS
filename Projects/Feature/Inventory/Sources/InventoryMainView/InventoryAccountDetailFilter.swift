//
//  InventoryAccountDetailFilter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryAccountDetailFilter

@Reducer
public struct InventoryAccountDetailFilter {
  @ObservableState
  public struct State {
    var headerType = HeaderViewFeature.State(.init(title: "필터", type: .depth2Default))
  }

  public enum Action: Equatable {
    case header(HeaderViewFeature.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: \.header) {
      HeaderViewFeature()
    }

    Reduce { _, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
