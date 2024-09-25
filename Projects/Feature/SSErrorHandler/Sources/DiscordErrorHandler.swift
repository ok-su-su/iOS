//
//  DiscordErrorHandler.swift
//  SSErrorHandler
//
//  Created by MaraMincho on 9/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation
import OSLog
import SSNotification

// MARK: - DiscordErrorHandler

public final class DiscordErrorHandler {
  public static let shared = DiscordErrorHandler()
  var subscription: AnyCancellable?
  private init() {}

  public func registerDiscordLogSystem() {
    subscription = NotificationCenter.default.publisher(for: SSNotificationName.logError)
      .sink { @Sendable errorObjectOutput in
        let errorObject = errorObjectOutput.object as? String
        Self.sendErrorToDiscord(errorMessage: errorObject)
      }
  }

  public func removeDiscordLogSystem() {
    subscription = nil
  }

  @Sendable private static func sendErrorToDiscord(errorMessage message: String?) {
    guard let message else {
      return
    }
    guard
      let webhookURLString = Bundle(for: self).infoDictionary?["DISCORD_WEB_HOOK_URL"] as? String,
      let webhookURL = URL(string: webhookURLString)
    else {
      os_log("Discord Web Hook URL이 잘못되었습니다. 확인해주세요")
      return
    }
    let messages = message.splitByLength(1500)

    Task {
      do {
        for message in messages {
          try await sendDiscordMessage(message, url: webhookURL)
        }
        os_log("Success to send discord message")
      } catch {
        os_log("Fail to send discord message")
      }
    }
  }

  @Sendable private static func sendDiscordMessage(_ message: String, url: URL) async throws {
    let payload: [String: Any] = ["content": message]
    guard let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
      os_log("Json 직렬화가 불가능 합니다. 확인해주세요")
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    _ = try await URLSession.shared.data(for: request)
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
