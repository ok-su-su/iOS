//
//  CreateLedgerRouter.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

// MARK: - CreateLedgerRouter

@Reducer
struct CreateLedgerRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<CreateLedgerRouterPath.State> = .init()
    var root: CreateLedgerCategory.State = .init()
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<CreateLedgerRouterPath>)
    case push(CreateLedgerRouterPath.State)
    case endedScreen(CreateLedgerRouterPath.State)
    case root(CreateLedgerCategory.Action)
  }

  func endedScreen(_ state: inout State, _ endedScreenState: CreateLedgerRouterPath.State) -> Effect<Action> {
    switch endedScreenState {
    default:
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.root, action: \.root) {
      CreateLedgerCategory()
    }
    Reduce { state, action in
      switch action {
      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        return .merge(
          .publisher {
            CreateLedgerRouterPathPublisher
              .publisher()
              .map{ .push($0)}
          },
          .publisher{
            CreateLedgerRouterPathPublisher
              .endedScreenPublisher()
              .map{ .endedScreen($0)}
          }
        )

      case .path:
        return .none

      case let .push(currentState):
        state.path.append(currentState)
        return .none

      case let .endedScreen(currentState):
        return endedScreen(&state, currentState)

      case .root:
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where Self.State == CreateLedgerRouter.State, Self.Action == CreateLedgerRouter.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
