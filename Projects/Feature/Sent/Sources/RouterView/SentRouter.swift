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
    var headerView = HeaderViewFeature.State(.init(type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
  }

  enum Action {
    case onAppear(Bool)
    case sentMain(SentMain.Action)
    case path(StackAction<Path.State, Path.Action>)
    case headerView(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.tabBar, action: /Action.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.sentMain, action: \.sentMain) {
      SentMain()
    }
    Scope(state: \.headerView, action: /Action.headerView) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none

      // MARK: - Routing

      case .sentMain(.tappedFirstButton):
        return .none

      case .sentMain(.filterButtonTapped):
        state.path.removeAll()
        state.path.append(.sentEnvelopeFilter())
        return .none

      case let .path(action):
        switch action {
        case .element(id: _, action: .sentMain(.filterButtonTapped)):

          return .none
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }

  init() {}
}

// MARK: SentRouter.Path

extension SentRouter {
  @Reducer
  struct Path {
    init() {}
    @ObservableState
    enum State {
      case sentEnvelopeFilter(SentEnvelopeFilter.State = .init())
      case sentMain(SentMain.State = .init())
    }

    enum Action {
      case sentEnvelopeFilter(SentEnvelopeFilter.Action)
      case sentMain(SentMain.Action)
    }

    var body: some Reducer<State, Action> {
      Scope(state: /State.sentEnvelopeFilter, action: /Action.sentEnvelopeFilter) {
        SentEnvelopeFilter()
      }
      Scope(state: /State.sentMain, action: /Action.sentMain) {
        SentMain()
      }
      Reduce { _, _ in
        return .none
      }
    }
  }
}
