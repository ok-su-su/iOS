//
//  ssRun.swift
//  FeatureAction
//
//  Created by MaraMincho on 9/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSNotification
import SSPersistancy

public extension Effect {
  static func ssRun(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (_ send: Send<Action>) async throws -> Void,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
  ) -> Self {
    // Show Default Network Alert
    let defaultErrorHandler: @Sendable (_ error: Error, _ send: Send<Action>) async -> Void = { _, _ in
      NotificationCenter.default.post(name: SSNotificationName.showDefaultNetworkErrorAlert, object: nil)
    }
    return .run(priority: priority, operation: operation) { error, send in

      let errorDescription = String(customDumping: error)

      // LogError
      let errorMessage =
        """
        \(errorDescription)
        FileID: \(fileID.description)
        filePath: \(filePath.description)
        line: \(line.description)
        column: \(column.description)
        date: \(Date.now.description)
        userID: \(SSTokenManager.shared.getUserID()?.description ?? "Unknwon")
        """
      NotificationCenter.default.post(name: SSNotificationName.logError, object: errorMessage)

      // Select Error Handler
      let currentErrorHandler = handler == nil ? defaultErrorHandler : handler!
      await currentErrorHandler(error, send)

      // System Log
      reportIssue(
        """
        An "Effect.run" returned from "\(fileID):\(line)" threw an unhandled error. …

        \(String(customDumping: error))

        All non-cancellation errors must be explicitly handled via the "catch" parameter \
        on "Effect.run", or via a "do" block.
        """,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    }
  }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }

  subscript(safeBounds bounds: Range<Int>) -> ArraySlice<Element>? {
    let safeLowerBound = Swift.max(bounds.lowerBound, startIndex)
    let safeUpperBound = Swift.min(bounds.upperBound, endIndex)
    guard safeLowerBound < safeUpperBound else {
      return nil
    }
    return self[safeLowerBound ..< safeUpperBound]
  }
}
