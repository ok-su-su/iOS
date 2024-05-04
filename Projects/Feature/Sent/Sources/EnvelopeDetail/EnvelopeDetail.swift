//
//  EnvelopeDetail.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct EnvelopeDetail {
  @ObservableState
  struct State {
    var isOnAppear = false
  }

  enum Action: Equatable {
    case onAppear(Bool)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
