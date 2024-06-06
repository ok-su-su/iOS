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
    case runTask
  }

  private var routingPublisher = SSLaunchScreenBuilderRouterPublisher.shared
  private var helper = LaunchScreenHelper()

  init() {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        routingPublisher.send(.launchTaskWillRun)
        return .send(.runTask)

      case .runTask:
        return .run { [helper, routingPublisher] _ in
          let taskResult = await helper.runAppInitTask()
          routingPublisher.send(.launchTaskDidRun(taskResult))
        }
      }
    }
  }
}
