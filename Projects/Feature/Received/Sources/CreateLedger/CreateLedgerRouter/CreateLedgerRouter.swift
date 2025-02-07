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
import OSLog
import SSNotification

// MARK: - CreateLedgerRouter

@Reducer
struct CreateLedgerRouter: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var path: StackState<CreateLedgerRouterPath.State> = .init()
    var root: CreateLedgerCategory.State = .init()
    var header: HeaderViewFeature.State = .init(
      .init(type: .depthProgressBar(Double(1) / 3)),
      enableDismissAction: false
    )
    init() {
      CreateLedgerSharedState.resetBody()
    }
  }

  enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case path(StackActionOf<CreateLedgerRouterPath>)
    case push(CreateLedgerRouterPath.State)
    case endedScreen(CreateLedgerRouterPath.State)
    case root(CreateLedgerCategory.Action)
    case updateHeader
  }

  @Dependency(\.createLedgerNetwork) var network
  @Dependency(\.receivedMainUpdatePublisher) var receivedMainUpdatePublisher

  func endedScreen(_: inout State, _ endedScreenState: CreateLedgerRouterPath.State) -> Effect<Action> {
    switch endedScreenState {
    case .date:
      return .ssRun { _ in
        let requestData = try CreateLedgerSharedState.getRequestBodyData()
        try await network.createLedgers(requestData)
        receivedMainUpdatePublisher.sendUpdatePage()
        await dismiss()
      }
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
          return .ssRun { _ in
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
              .receive(on: RunLoop.main)
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
