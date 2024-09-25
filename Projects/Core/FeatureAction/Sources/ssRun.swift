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
    return .run(priority: priority, operation: operation) { error, _ in
      let errorObject: [String: Any] = [
        "ErrorMessage": String(customDumping: error),
        "FileID": fileID.description,
        "filePath": filePath.description,
        "line": line.description,
        "column": column.description,
      ]
      NotificationCenter.default.post(name: SSNotificationName.showDefaultNetworkErrorAlert, object: errorObject)

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
