//
//  Reudcer+.swift
//  FeatureAction
//
//  Created by MaraMincho on 6/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - FeatureViewAction

// var body: some Reducer<State, Action> {
//  Reduce { state, action in
//    switch action {
//    case let .view(currentAction):
//      return viewAction(&state, currentAction)
//    case let .inner(currentAction):
//      return innerAction(&state, currentAction)
//    case let .async(currentAction):
//      return asyncAction(&state, currentAction)
//    case let .scope(currentAction):
//      return scopeAction(&state, currentAction)
//    case let .delegate(currentAction):
//      return delegateAction(&state, currentAction)
//    }
//  }
// }
// var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
//  switch action {
//  case let .onAppear(isAppear):
//    if state.isOnAppear {
//      return .none
//    }
//    state.isOnAppear = isAppear
//    return .none
//  }
// }
// var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { _, _ in
//  return .none
// }
// var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { _, _ in
//  return .none
// }
// var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> = { _, _ in
//  return .none
// }
// var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> = { _, _ in
//  return .none
// }

public protocol FeatureViewAction: Reducer where Action: FeatureAction {
  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> { get set }
}

// MARK: - FeatureScopeAction

public protocol FeatureScopeAction: Reducer where Action: FeatureAction {
  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> { get set }
}

// MARK: - FeatureAsyncAction

public protocol FeatureAsyncAction: Reducer where Action: FeatureAction {
  var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> { get set
  }
}

// MARK: - FeatureInnerAction

public protocol FeatureInnerAction: Reducer where Action: FeatureAction {
  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> { get }
}

// MARK: - FeatureDelegateAction

public protocol FeatureDelegateAction: Reducer where Action: FeatureAction {
  var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> { get set }
}
