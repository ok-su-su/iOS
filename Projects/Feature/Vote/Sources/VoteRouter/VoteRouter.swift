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
    case initPush(VoteRouterInitialPath)
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
          return .run { _ in
            await dismiss()
          }
        }
        state.isOnAppear = isAppear
        return .merge(
          .publisher {
            VotePathPublisher.shared
              .pathPublisher()
              .map { path in .pushPath(path) }
          }, .send(.initPush(state.initialPath))
        )
        .cancellable(id: CancelID.observePush, cancelInFlight: true)

      case .path:
        return .none

      case let .pushPath(nextPath):
        if nextPath == .dismiss(.init()) {
          return .run { _ in
            await dismiss()
          }
        }
        state.path.append(nextPath)
        return .none

      case let .initPush(path):
        switch path {
        case .search:
          state.path.append(.search(.init()))
        case .voteDetail(.mine):
          state.path.append(.myVote(.init()))
        case .voteDetail(.other):
          state.path.append(.otherVoteDetail(.init()))
        case .write:
          state.path.append(.write(.init()))
        }
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
