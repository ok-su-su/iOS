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
        state.path.append(.specificEnvelopeHistoryList(.init()))
        return .none

      case .path(.push(id: _, state: _)):
        return .none

      case let .path(.element(id: _, action: action)):
        switch action {
        case .specificEnvelopeHistoryList(.delegate(.pushDeleteScene)) :
          state.path.append(<#T##newElement: Path.State##Path.State#>)
          return .none
        case .specificEnvelopeHistoryList:
          return .none
        }
        

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
