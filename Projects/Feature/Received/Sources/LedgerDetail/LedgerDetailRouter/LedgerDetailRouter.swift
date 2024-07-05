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
import SSEnvelope

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

  func handlePath(state: inout State, action: StackActionOf<LedgerDetailPath>) -> Effect<Action> {
    switch action {
    case let .element(id: _, action: .envelopeDetail(.delegate(currentAction))):
      return handleEnvelopeDetailDelegateAction(state: &state, action: currentAction)
    case .element(id: _, action: _):
      return .none
    case .popFrom(id: _):
      return .none
    case .push(id: _, state: _):
      return .none
    }
  }

  func handleEnvelopeDetailDelegateAction(state _: inout State, action: SpecificEnvelopeDetailReducer.Action.DelegateAction) -> Effect<Action> {
    switch action {
    case let .tappedEnvelopeEditButton(property):
      return .run { [id = property.id] _ in
        let editState = try await SpecificEnvelopeEditReducer.State(envelopeID: id)
        LedgerDetailRouterPublisher.send(.envelopeEdit(editState))
      }
    case let .tappedDeleteConfirmButton(id):
      return .none
//      SpecificEnvelopeSharedState.shared.setDeleteEnvelopeID(id)
//      return .send(.envelopeHistory(.inner(.updateEnvelopeDetailIfUserDeleteEnvelope)))
    }
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
