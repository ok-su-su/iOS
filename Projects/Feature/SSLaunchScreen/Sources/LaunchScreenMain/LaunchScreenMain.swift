//
//  LaunchScreenMain.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Foundation

@Reducer
struct LaunchScreenMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var showMandatoryUpdateAlert: Bool = false
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case mandatoryUpdateAlert(Bool)
  }

  private var routingPublisher = SSLaunchScreenBuilderRouterPublisher.shared

  init() {}

  @Dependency(\.launchScreenNetwork) var launchScreenNetwork
  @Dependency(\.launchScreenTokenNetwork) var tokenNetwork
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        routingPublisher.send(.launchTaskWillRun)
        let appVersion = InfoPlistConstants.appVersion

        return .run { send in
          if await launchScreenNetwork.getIsMandatoryUpdate(appVersion) {
            await send(.mandatoryUpdateAlert(true))
            return
          }

          // Token 검사
          let taskResult = await tokenNetwork.checkTokenValid()
          routingPublisher.send(.launchTaskDidRun(taskResult))
        }

      case let .mandatoryUpdateAlert(val):
        state.showMandatoryUpdateAlert = val
        return .none
      }
    }
  }
}
