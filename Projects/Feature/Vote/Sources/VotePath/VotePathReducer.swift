//
//  VotePathReducer.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct VotePathReducer {
  @ObservableState
  struct State: Equatable {
    var path: StackState<VotePathDestination.State> = .init()

    init() {}
  }

  enum Action: Equatable {
    case registerReducer
    case path(StackActionOf<VotePathDestination>)
    case push(VotePathDestination.State)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .registerReducer:
        return .publisher {
          VotePathPublisher
            .shared
            .pathPublisher()
            .map { .push($0) }
        }
      case let .push(pathState):
        state.path.append(pathState)
        return .none

      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
