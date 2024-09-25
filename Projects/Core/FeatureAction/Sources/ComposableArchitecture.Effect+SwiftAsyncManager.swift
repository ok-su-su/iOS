//
//  ComposableArchitecture.Effect+SwiftAsyncManager.swift
//  FeatureAction
//
//  Created by MaraMincho on 9/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftAsyncMutex

public extension ComposableArchitecture.Effect {
  static func runWithTCAMutex(
    _ mutex: TCAMutex,
    minimumTimeDuration: Double = 0.3,
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (Send<Action>) async throws -> Void,
    startOperation: (@Sendable (Send<Action>) async throws -> Void)? = nil,
    endOperation: (@Sendable (Send<Action>) async throws -> Void)? = nil,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil
  ) -> Effect<Action> {
    let currentOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      // Start Point
      let initTime = Date()
      await mutex.willTask()
      try await startOperation?(send)

      // Operation Point
      do {
        try await operation(send)
      } catch {
        await handler?(error, send)
        return
      }

      // End Point
      let elapsedTime = Date().timeIntervalSince(initTime)
      if elapsedTime < minimumTimeDuration {
        let remainingTime = minimumTimeDuration - elapsedTime
        try await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
      }
      try await endOperation?(send)
      await mutex.didTask()
    }

    return .ssRun(priority: priority, operation: currentOperation, catch: handler)
  }
}
