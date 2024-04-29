//
//  SentRouter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - SentRouter

@Reducer
struct SentRouter {
  @ObservableState
  struct State {
    var path = StackState<Path.State>()
    var isOnAppear = false
  }

  enum Action {
    case onAppear(Bool)
    case path(StackAction<Path.State, Path.Action>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
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
    enum State {
//      case sentMain(SentMain.State = .init())
//      case sentEnvelopeFilter(SentEnvelopeFilter.State = .init())
    }

    enum Action {
//      case sentMain(SentMain.Action)
//      case sentEnvelopeFilter(SentEnvelopeFilter.Action)
    }

    var body: some Reducer<State, Action> {
//      Scope(state: /State.sentMain, action: /Action.sentMain) {
//        SentMain()
//      }
//      Scope(state: /State.sentEnvelopeFilter, action: /Action.sentEnvelopeFilter) {
//        SentEnvelopeFilter()
//      }
      Reduce { _, _ in
        return .none
      }
    }
  }
}
