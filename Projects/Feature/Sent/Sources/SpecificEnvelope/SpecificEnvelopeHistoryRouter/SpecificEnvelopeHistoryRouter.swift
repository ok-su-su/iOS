//
//  SpecificEnvelopeHistoryRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation
import SSEnvelope

// MARK: - SpecificEnvelopeHistoryRouter

@Reducer
struct SpecificEnvelopeHistoryRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<SpecificEnvelopeHistoryRouterPath.State> = .init()
    var envelopeHistory: SpecificEnvelopeHistoryList.State
    init(envelopeProperty: EnvelopeProperty) {
      envelopeHistory = .init(envelopeProperty: envelopeProperty)
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case push(SpecificEnvelopeHistoryRouterPath.State)
    case path(StackActionOf<SpecificEnvelopeHistoryRouterPath>)
    case envelopeHistory(SpecificEnvelopeHistoryList.Action)
  }

  enum CancelID {
    case pushPublisher
  }

  func handlePath(state: inout State, action: StackActionOf<SpecificEnvelopeHistoryRouterPath>) -> Effect<Action> {
    switch action {
    case let .element(id: _, action: .specificEnvelopeHistoryDetail(.delegate(currentAction))):
      return handleEnvelopeDetailDelegateAction(state: &state, action: currentAction)
    case .element(id: _, action: _):
      return .none
    case .popFrom(id: _):
      return .none
    case .push(id: _, state: _):
      return .none
    }
  }

  @Dependency(\.envelopeNetwork) var network
  func handleEnvelopeDetailDelegateAction(state _: inout State, action: SpecificEnvelopeDetailReducer.Action.DelegateAction) -> Effect<Action> {
    switch action {
    case let .tappedEnvelopeEditButton(property):
      return .ssRun { [id = property.envelope.id] _ in
        let editState = try await SpecificEnvelopeEditReducer.State(envelopeID: id)
        SpecificEnvelopeHistoryRouterPublisher.push(.specificEnvelopeHistoryEdit(editState))
      }
    }
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Scope(state: \.envelopeHistory, action: \.envelopeHistory) {
      SpecificEnvelopeHistoryList()
    }
    Reduce { state, action in
      switch action {
      case .path(.push(id: _, state: _)):
        return .none

      case let .path(currentAction):
        return handlePath(state: &state, action: currentAction)

      case .envelopeHistory:
        return .none

      case let .onAppear(appear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = appear
        return .publisher {
          SpecificEnvelopeHistoryRouterPublisher
            .publisher
            .receive(on: RunLoop.main)
            .map { .push($0) }
        }
        .cancellable(id: CancelID.pushPublisher, cancelInFlight: true)

      case let .push(pushState):
        state.path.append(pushState)
        return .none
      }
    }.forEach(\.path, action: \.path)
  }
}
