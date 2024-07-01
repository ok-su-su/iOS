//
//  CreateLedgerRouter.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
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
    var header: HeaderViewFeature.State = .init(
      .init(type: .depthProgressBar(Double(1 / 3))),
      enableDismissAction: false
    )
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case path(StackActionOf<CreateLedgerRouterPath>)
    case push(CreateLedgerRouterPath.State)
    case endedScreen(CreateLedgerRouterPath.State)
    case root(CreateLedgerCategory.Action)
    case updateHeader
  }

  func endedScreen(_: inout State, _ endedScreenState: CreateLedgerRouterPath.State) -> Effect<Action> {
    switch endedScreenState {
    default:
      return .none
    }
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Scope(state: \.root, action: \.root) {
      CreateLedgerCategory()
    }
    Reduce { state, action in
      switch action {
      case .header(.tappedDismissButton):
        if state.path.isEmpty {
          return .run { _ in
            await dismiss()
          }
        }
        _ = state.path.popLast()
        return .send(.updateHeader)

      case .header:
        return .none

      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        return .merge(
          .publisher {
            CreateLedgerRouterPathPublisher
              .publisher()
              .map { .push($0) }
          },
          .publisher {
            CreateLedgerRouterPathPublisher
              .endedScreenPublisher()
              .map { .endedScreen($0) }
          }
        )

      case .path:
        return .none

      case let .push(currentState):
        state.path.append(currentState)
        return .send(.updateHeader)

      case let .endedScreen(currentState):
        return endedScreen(&state, currentState)

      case .root:
        return .none
      case .updateHeader:
        let currentProgress = Double(state.path.count + 1) / 3
        state.header.updateProperty(.init(type: .depthProgressBar(currentProgress)))
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
