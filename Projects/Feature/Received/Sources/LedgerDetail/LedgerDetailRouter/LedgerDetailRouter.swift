//
//  LedgerDetailRouter.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

// MARK: - LedgerDetailRouter

@Reducer
struct LedgerDetailRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<LedgerDetailPath.State> = .init()
    var ledgerDetailMain: LedgerDetailMain.State
    init(_ state: LedgerDetailMain.State) {
      ledgerDetailMain = state
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case ledgerDetailMain(LedgerDetailMain.Action)
    case path(StackActionOf<LedgerDetailPath>)
    case push(LedgerDetailPath.State)
  }

  enum CancelID {
    case routePublisherID
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.ledgerDetailMain, action: \.ledgerDetailMain) {
      LedgerDetailMain()
    }

    Reduce { state, action in
      switch action {
      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        return .publisher {
          LedgerDetailRouterPublisher
            .publisher()
            .map { .push($0) }
        }
        .cancellable(id: CancelID.routePublisherID, cancelInFlight: true)

      case .path:
        return .none

      case .ledgerDetailMain:
        return .none
      case let .push(pathState):
        state.path.append(pathState)
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where Self.State == LedgerDetailRouter.State, Self.Action == LedgerDetailRouter.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
