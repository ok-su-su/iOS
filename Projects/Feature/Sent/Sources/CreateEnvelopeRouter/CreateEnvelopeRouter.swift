//
//  CreateEnvelopeRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeRouter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var path = StackState<Path.State>()
    init() {}
  }

  enum Action {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
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

extension CreateEnvelopeRouter {
  
  @Reducer
  enum Path {
    case createEnvelopePrice(CreateEnvelopePrice)
  }
}
