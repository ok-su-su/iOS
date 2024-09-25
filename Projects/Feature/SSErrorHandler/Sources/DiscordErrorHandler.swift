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

    let payload: [String: Any] = ["content": message]
    // JSON 데이터로 변환
    guard let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
      os_log("Json 직렬화가 불가능 합니다. 확인해주세요")
      return
    }

    // URL 요청 설정
    var request = URLRequest(url: webhookURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    // URLSession을 통해 요청 전송
    let task = URLSession.shared.dataTask(with: request) { _, _, error in
      if let error {
        os_log("Error sending message to Discord: \(error)")
      } else {
        os_log("Message sent successfully to Discord")
      }
    }

    task.resume()
  }
}
