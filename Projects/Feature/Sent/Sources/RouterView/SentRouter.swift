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
  }

  enum Action {
    case onAppear(Bool)
    case path(StackAction<Path.State, Path.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .path(action):
        switch action {
        case .element(id: _, action: .sentEnvelopeFilter):
          return .none
        case .element(id: _, action: .sentMain(.delegate(.pushSearchEnvelope))):
          state.path.append(.searchEnvelope(SearchEnvelope.State()))
          return .none
        default:
          return .none
        }
      case .onAppear(true):
        state.path.append(.sentMain(SentMain.State()))
        return .none
      case .onAppear(false):
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
    case searchEnvelope(SearchEnvelope)
  }
}

    case envelopeDetail(EnvelopeDetail)