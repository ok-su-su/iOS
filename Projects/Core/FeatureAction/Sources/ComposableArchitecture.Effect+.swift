//
//  ComposableArchitecture.Effect+.swift
//  FeatureAction
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

public extension ComposableArchitecture.Effect {
  static func runWithStartFinishAction(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (Send<Action>) async throws -> Void,
    startOperation: @escaping @Sendable (Send<Action>) async throws -> Void,
    endOperation: @escaping @Sendable (Send<Action>) async throws -> Void,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil
  ) -> Effect<Action> {
    let currentOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      try await startOperation(send)
      try await operation(send)
      try await endOperation(send)
    }
    return .run(priority: priority, operation: currentOperation, catch: handler)
  }
}
