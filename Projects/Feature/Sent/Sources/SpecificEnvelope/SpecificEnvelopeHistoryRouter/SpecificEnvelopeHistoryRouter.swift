//
//  SpecificEnvelopeHistoryRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - SpecificEnvelopeHistoryRouter

@Reducer
struct SpecificEnvelopeHistoryRouter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var path: StackState<Path.State> = .init()
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .send(.path(.push(id: 0, state: .specificEnvelopeHistoryList(.init()))))
      case let .path(.push(id: _, state: pathState)):
        switch pathState {
        case let .specificEnvelopeHistoryList(currentState):
          state.path.append(.specificEnvelopeHistoryList(currentState))
          return .none
        }

      case let .path(.element(id: id, action: action)):
        return .none

      case let .path(.popFrom(id: id)):
        return .none
      }

    }.forEach(\.path, action: \.path)
  }
}

// MARK: SpecificEnvelopeHistoryRouter.Path

extension SpecificEnvelopeHistoryRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case specificEnvelopeHistoryList(SpecificEnvelopeHistoryList)
  }
}
