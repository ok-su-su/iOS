//
//  MyPageRouterAndPathReducer.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

@Reducer
struct MyPageRouterAndPathReducer {
  struct State: Equatable {
    var path: StackState<MyPageNavigationPath.State> = .init()
    var presentFeedBack: Bool = false
    var presentPrivacyPolicy: Bool = false
    var presentLogoutAlert = false
    var presentResignAlert = false
  }

  enum Action: Equatable {
    case path(StackActionOf<MyPageNavigationPath>)
    case sinkPublisher
    case push(MyPageNavigationPath.State)
    case routing(MyPageRouterPath)
    case present(PresentAction)
  }

  @CasePathable
  enum PresentAction: Equatable {
    case presentFeedBack(Bool)
    case presentPrivacyPolicy(Bool)
    case presentLogoutAlert(Bool)
    case presentResignAlert(Bool)
  }

  private func sinkPublisher() -> Effect<Action> {
    return .merge(
      .publisher {
        MyPageRouterAndPathPublisher
          .pathPublisher
          .map { .push($0) }
      },
      .publisher {
        MyPageRouterAndPathPublisher
          .routingPublisher
          .map { .routing($0) }
      }
    )
  }

  private func routeAction(_ state: inout State, type: MyPageRouterPath) -> Effect<Action> {
    switch type {
    case .privacyPolicy:
      state.presentPrivacyPolicy = true
      return .none

    case .appVersion:
      return .none

    case .logout:
      state.presentLogoutAlert = true
      return .none
    case .resign:
      state.presentResignAlert = true
      return .none

    case .feedBack:
      state.presentFeedBack = true
      return .none
    }
  }

  func presentAction(_ state: inout State, _ action: PresentAction) -> Effect<Action> {
    switch action {
    case let .presentPrivacyPolicy(present):
      state.presentPrivacyPolicy = present
      return .none

    case let .presentFeedBack(present):
      state.presentFeedBack = present
      return .none

    case let .presentLogoutAlert(present):
      state.presentLogoutAlert = present
      return .none

    case let .presentResignAlert(present):
      state.presentResignAlert = present
      return .none
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .sinkPublisher:
        return sinkPublisher()

      case .path:
        return .none

      case let .push(pathState):
        state.path.append(pathState)
        return .none

      case let .routing(routeType):
        return routeAction(&state, type: routeType)

      case let .present(currentAction):
        return presentAction(&state, currentAction)
      }
    }
    .forEach(\.path, action: \.path)
  }
}
