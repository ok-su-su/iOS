//
//  CreateEnvelopeRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - CreateEnvelopeRouter

@Reducer
struct CreateEnvelopeRouter {
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  struct State {
    var isOnAppear = false
    var path = StackState<Path.State>()
    var header = HeaderViewFeature.State(.init(type: .depthProgressBar(12 / 96)))
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    init() {
      _createEnvelopeProperty = Shared(.init())
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
    case header(HeaderViewFeature.Action)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature(enableDismissAction: false)
    }
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .createEnvelopePrice(.delegate(.dismissCreateFlow)))):
        return .run { _ in
          await dismiss()
        }
      case .onAppear(true):
        state.path.append(.createEnvelopePrice(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .none
      case .header(.tappedDismissButton):
        _ = state.path.popLast()
        if state.path.isEmpty {
          return .run { _ in await dismiss() }
        }
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
    case createEnvelopeName(CreateEnvelopeName)
  }
}
