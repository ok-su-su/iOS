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
  struct State {
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
    case let .element(id: id, action: action):
      return .none
    case let .popFrom(id: id):
      return .none
    case let .push(id: id, state: state):
      return .none
    }
  }

  @Dependency(\.envelopeNetwork) var network
  func handleEnvelopeDetailDelegateAction(state: inout State, action: SpecificEnvelopeDetailReducer.Action.DelegateAction) -> Effect<Action> {
    switch action {
    case let .tappedEnvelopeEditButton(property):
      return .run { [id = property.id] _ in
        let editState = try await SpecificEventEditReducer.State(envelopeID: id)
        SpecificEnvelopeHistoryRouterPublisher.push(.specificEnvelopeHistoryEdit(editState))
      }
    case let .tappedDeleteConfirmButton(id):
      state.envelopeHistory.envelopeContents.removeAll(where: { $0.id == id })
      return .none
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

      case .path:
        return .none

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

// MARK: - SpecificEnvelopeHistoryRouterPath

@Reducer(state: .equatable, action: .equatable)
enum SpecificEnvelopeHistoryRouterPath {
  case specificEnvelopeHistoryList(SpecificEnvelopeHistoryList)
  case specificEnvelopeHistoryDetail(SpecificEnvelopeDetailReducer)
  case specificEnvelopeHistoryEdit(SpecificEventEditReducer)
}
