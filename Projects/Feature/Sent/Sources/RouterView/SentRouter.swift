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
  }

  enum Action {
    case onAppear(Bool)
    case sentMain(SentMain.Action)
    case path(StackAction<Path.State, Path.Action>)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.sentMain, action: \.sentMain) {
      SentMain()
    }
    Reduce { state, action in
      switch action {
      case .sentMain(.filterButtonTapped):
        state.path.append(.sentEnvelopeFilter(SentEnvelopeFilter.State(sentPeople: [
          .init(name: "제제"),
          .init(name: "다함"),
          .init(name: "스위치"),
          .init(name: "누구"),
          .init(name: "정다한"),
          .init(name: "스위치"),
          .init(name: "바보"),
          .init(name: "보바"),
        ])))
        return .none
      case let .path(action):
        switch action {
        case .element(id: _, action: .sentEnvelopeFilter):
          return .none
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
    case sentMain(SentMain)
  }
}
