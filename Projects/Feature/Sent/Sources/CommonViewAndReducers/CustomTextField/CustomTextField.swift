//
//  CustomTextField.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
struct CustomTextField {
  @ObservableState
  struct State {
    var isOnAppear = false
    var text: String
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case changeTextField(String)
    case closeButtonTapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none

      case .closeButtonTapped:
        state.text = ""
        return .none

      case let .changeTextField(text):
        os_log("textField = \(text)")
        state.text = text
        return .none
      }
    }
  }
}
