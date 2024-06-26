//
//  SpecificEnvelopeHistoryRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

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
  case specificEnvelopeHistoryDetail(SpecificEnvelopeHistoryDetail)
  case specificEnvelopeHistoryEdit(SpecificEnvelopeHistoryEdit)
}
