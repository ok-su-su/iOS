//
//  Reudcer+.swift
//  FeatureAction
//
//  Created by MaraMincho on 6/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - FeatureViewActionWithClosure

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

public protocol FeatureViewActionWithClosure: Reducer where Action: FeatureAction {
  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> { get set }
}

// MARK: - FeatureViewAction

public protocol FeatureViewAction: Reducer where Action: FeatureAction {
  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action>
}

// MARK: - FeatureScopeActionWithClosure

public protocol FeatureScopeActionWithClosure: Reducer where Action: FeatureAction {
  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> { get set }
}

// MARK: - FeatureScopeAction

public protocol FeatureScopeAction: Reducer where Action: FeatureAction {
  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action>
}

// MARK: - FeatureAsyncActionWithClosure

public protocol FeatureAsyncActionWithClosure: Reducer where Action: FeatureAction {
  var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> { get set
  }
}

// MARK: - FeatureAsyncAction

public protocol FeatureAsyncAction: Reducer where Action: FeatureAction {
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action>
}

// MARK: - FeatureInnerActionWithClosure

public protocol FeatureInnerActionWithClosure: Reducer where Action: FeatureAction {
  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> { get }
}

// MARK: - FeatureInnerAction

public protocol FeatureInnerAction: Reducer where Action: FeatureAction {
  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action>
}

// MARK: - FeatureDelegateActionWithClosure

public protocol FeatureDelegateActionWithClosure: Reducer where Action: FeatureAction {
  var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> { get set }
}

// MARK: - FeatureDelegateAction

public protocol FeatureDelegateAction: Reducer where Action: FeatureAction {
  func delegateAction(_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action>
}
