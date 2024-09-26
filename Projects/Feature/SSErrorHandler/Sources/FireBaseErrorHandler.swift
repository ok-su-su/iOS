//
//  FireBaseErrorHandler.swift
//  SSErrorHandler
//
//  Created by MaraMincho on 9/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Combine
import Foundation
import OSLog
import SSNotification
import FirebaseAnalytics

// MARK: - DiscordErrorHandler

public final class FireBaseErrorHandler {
  public static let shared = FireBaseErrorHandler()
  var subscription: AnyCancellable?
  private init() {}

  public func registerFirebaseLogSystem() {
    subscription = NotificationCenter.default.publisher(for: SSNotificationName.logError)
      .sink { @Sendable errorObjectOutput in
        let errorObject = errorObjectOutput.object as? String
        Self.sendErrorToFirebase(errorMessage: errorObject)
      }
  }

  public func removeDiscordLogSystem() {
    subscription = nil
  }

  @Sendable private static func sendErrorToFirebase(errorMessage message: String?) {
    guard let message else {
      return
    }
    Analytics.logEvent("iOS Error", parameters: ["description": message])
  }
}

private extension String {
  func splitByLength(_ length: Int) -> [String] {
    var result: [String] = []
    var currentIndex = startIndex

    while currentIndex < endIndex {
      let nextIndex = index(currentIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
      result.append(String(self[currentIndex ..< nextIndex]))
      currentIndex = nextIndex
    }

    return result
  }
}
