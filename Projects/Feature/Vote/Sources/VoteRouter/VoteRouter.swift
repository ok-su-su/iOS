//
//  VoteRouter.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
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
    init(initialPath: VoteRouterInitialPath) {
      self.initialPath = initialPath
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<VoteRouterPath>)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        if state.path.isEmpty {
          state.isOnAppear = isAppear
          return .none
        }
        return .run { _ in
          await dismiss()
        }
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
