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
      self.ledgerDetailMain = state
    }
  }

  enum Action: Equatable  {
    case onAppear(Bool)
    case path(StackActionOf<LedgerDetailPath>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        return .none
      case .path:
        return .none
      }
    }
  }
}

extension Reducer where Self.State == LedgerDetailRouter.State, Self.Action == LedgerDetailRouter.Action {}
