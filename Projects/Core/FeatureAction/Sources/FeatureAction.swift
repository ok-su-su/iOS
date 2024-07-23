//
//  FeatureAction.swift
//  FeatureAction
//
//  Created by MaraMincho on 6/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - FeatureAction

public protocol FeatureAction {
  associatedtype ViewAction
  associatedtype InnerAction
  associatedtype AsyncAction
  associatedtype ScopeAction
  associatedtype DelegateAction

  /// NOTE: view 에서 사용되는 Action 을 정의합니다.
  static func view(_: ViewAction) -> Self

  /// NOTE: 그 외 Reducer 내부적으로 사용되는 Action 을 정의합니다.
  static func inner(_: InnerAction) -> Self

  /// NOTE: 비동기적으로 돌아가는 Action 을 정의합니다.
  static func async(_: AsyncAction) -> Self

  /// NOTE: 자식 Redcuer 에서 사용되는 Action 을 정의합니다.
  static func scope(_: ScopeAction) -> Self

  /// NOTE: 부모 Reducer 에서 사용되는 Action 을 정의합니다.
  static func delegate(_: DelegateAction) -> Self
}

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
