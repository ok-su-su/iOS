//
//  CreateEnvelopeRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - CreateEnvelopeRouter

@Reducer
struct CreateEnvelopeRouter {
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  struct State {
    var isOnAppear = false
    var path = StackState<Path.State>()
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .createEnvelopePrice(.view(.dismissButtonTapped)))):

        return .run { _ in
          await dismiss()
        }
      case .onAppear(true):
        state.path.append(.createEnvelopePrice(.init()))
        return .none
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

// MARK: CreateEnvelopeRouter.Path

extension CreateEnvelopeRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case createEnvelopePrice(CreateEnvelopePrice)
  }
}
