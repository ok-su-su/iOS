//
//  SentRouter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

// MARK: - SentRouter

@Reducer
struct SentRouter {
  @ObservableState
  struct State {
    var path = StackState<Path.State>()
    var isOnAppear = false
    var sentMain = SentMain.State()
    var headerView = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
  }

  enum Action {
    case onAppear(Bool)
    case sentMain(SentMain.Action)
    case path(StackAction<Path.State, Path.Action>)
    case headerView(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.tabBar, action: /Action.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.sentMain, action: \.sentMain) {
      SentMain()
    }
    Scope(state: \.headerView, action: \.headerView) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case .sentMain(.filterButtonTapped):
        state.path.append(.sentEnvelopeFilter(SentEnvelopeFilter.State(sentPeople: [])))
        return .none
      case let .path(action):
        switch action {
        default:
          return .none
        }
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  init() {}
}

// MARK: SentRouter.Path

extension SentRouter {
  @Reducer
  enum Path {
    case sentEnvelopeFilter(SentEnvelopeFilter)
  }
}
