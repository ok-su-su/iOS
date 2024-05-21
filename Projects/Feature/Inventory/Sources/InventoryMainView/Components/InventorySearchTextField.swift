//
//  InventorySearchTextField.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct InventorySearchTextField {
  @ObservableState
  public struct State {
    @Shared var text: String
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case didTapCloseButton
  }

  public var body: some Reducer<State, Action> {
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
