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
  }

  enum Action: Equatable {
    case path(StackActionOf<MyPageNavigationPath>)
    case sinkPublisher
    case push(MyPageNavigationPath.State)
    case routing(MyPageRouterPath)
  }

  private func sinkPublisher() -> Effect<Action> {
    return .merge(
      .publisher{
        MyPageRouterPublisher
          .pathPublisher
          .map{ .push($0) }
      },
      .publisher{
        MyPageRouterPublisher
          .routingPublisher
          .map{ .routing($0) }
      }
    )
  }

  private func routeAction(_ state: inout State, type: MyPageRouterPath) -> Effect<Action>  {
    switch type {
    case .myPageInformation: // 제거
      return .none

    case .connectedSocialAccount: // 안쓰는 타입 제거
      return .none

    case .exportExcel: // 제거
      return .none

    case .privacyPolicy:
      //TODO: -
      return .none
    case .appVersion:
      return .none

    case .logout:
      //TODO: showAlert -
      return .none

    case .resign:
    //TODO: Show Alert -
    case .feedBack:
      //TODO: Show Safari
    }
    return .none
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .sinkPublisher:
        return .none
      case .path:
        return .none
      case let .push(pathState):
        state.path.append(pathState)
        return .none
      case let .routing(routeType):
        return routeAction(&state, type: routeType)
      }
    }
    .forEach(\.path, action: \.path)
  }
}
