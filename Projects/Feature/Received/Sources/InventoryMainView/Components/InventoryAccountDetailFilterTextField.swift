//
//  InventoryAccountDetailFilterTextField.swift
//  Inventory
//
//  Created by Kim dohyun on 6/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

// MARK: - InventoryAccountDetailTextField

@Reducer
public struct InventoryAccountDetailFilterTextField {
  @ObservableState
  public struct State {
    @Shared var text: String
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case didTapCloseButton
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .didTapCloseButton:
        state.text = ""
        return .none
      default:
        return .none
      }
    }
  }
}
