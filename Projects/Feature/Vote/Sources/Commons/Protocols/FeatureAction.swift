//
//  FeatureAction.swift
//  Profile
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

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
