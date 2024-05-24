//
//  VoteRouter.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Foundation

// MARK: - VoteRouter

@Reducer
struct VoteRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<VoteRouterPath.State> = .init()
    var initialPath: VoteRouterInitialPath
    var subscriber: AnyCancellable? = nil
    init(initialPath: VoteRouterInitialPath) {
      self.initialPath = initialPath
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case pushPath(VoteRouterPath.State)
    case path(StackActionOf<VoteRouterPath>)
  }

  enum CancelID {
    case observePush
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        if state.isOnAppear == true {
          return .none
        }
        state.isOnAppear = isAppear
        return .publisher {
          VotePathPublisher.shared
            .pathPublisher()
            .map { path in .pushPath(path) }
        }
        .cancellable(id: CancelID.observePush, cancelInFlight: true)
      case .path:
        return .none

      case let .pushPath(nextPath):
        state.path.append(nextPath)
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == VoteRouter.State, Action == VoteRouter.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
