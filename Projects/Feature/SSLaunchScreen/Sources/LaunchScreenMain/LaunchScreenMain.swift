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

  init() {}

  @Dependency(\.launchScreenNetwork) var launchScreenNetwork
  @Dependency(\.launchScreenTokenNetwork) var tokenNetwork
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        routingPublisher.send(.launchTaskWillRun)
        return .send(.runTask)

      case .runTask:
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return .run { _ in
          if await launchScreenNetwork.getIsMandatoryUpdate(appVersion) {
            
            return
          }

          /// Token 검사
          let taskResult = await tokenNetwork.checkTokenValid()
          routingPublisher.send(.launchTaskDidRun(taskResult))
        }
      }
    }
  }
}

fileprivate enum Constants {
  enum MandatoryUpdate {
    static let mandatoryUpdateTitle: String = "업데이트가 필요해요"
    static let mandatoryUpdateContent: String = "새로운 버전의 수수를 다운로드해주세요"
    static let mandatoryUpdateButtonLabel: String = "새로운 버전의 수수를 다운로드해주세요"
  }
}
