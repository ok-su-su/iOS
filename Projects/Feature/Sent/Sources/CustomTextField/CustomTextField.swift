//
//  CustomTextField.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CustomTextField {
  @ObservableState
  struct State {
    var isOnAppear = false
    @Shared var text: String
  }

  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case onAppear(Bool)
    case closeButtonTapped
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .closeButtonTapped:
        state.text = ""
        return .none
      default:
        return .none
      }
    }
  }
}
