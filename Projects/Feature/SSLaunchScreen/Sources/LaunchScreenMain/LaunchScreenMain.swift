//
//  LaunchScreenMain.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct LaunchScreenMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false

    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      }
    }
  }
}
