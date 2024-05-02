//
//  FloatingButton.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct FloatingButton {
  @ObservableState
  struct State {
    var isOnAppear = false
  }

  enum Action: Equatable {
    case tapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tapped:
        return .none
      }
    }
  }
}
