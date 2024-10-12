// 
//  SSFilter.swift
//  SSfilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture
import FeatureAction

@Reducer
struct SSFilterReducer: Sendable {

  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var isLoading: Bool = true
    @Shared var property:
    init () {}
  }

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable, Sendable {}

  enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  enum ScopeAction: Equatable, Sendable {}

  enum DelegateAction: Equatable, Sendable {}

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action>{
    switch action {
    case let .onAppear(isAppear) :
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == SSFilterReducer.State, Self.Action == SSFilterReducer.Action { }
