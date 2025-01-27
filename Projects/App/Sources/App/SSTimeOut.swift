//
//  SSTimeOut.swift
//  susu
//
//  Created by MaraMincho on 10/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SSInterceptor
import SSNotification
import SSPersistancy

final class SSTimeOut {
  private nonisolated(unsafe) static let shared = SSTimeOut()
  private var timeoutInterval: Int = 60 * 10
  private var enteredBackgroundDate: Date?
  private var initialLoading: Bool = false

  static func setTimeoutInterval(minute: Int, seconds: Int) {
    shared.timeoutInterval = minute * 60 + seconds
  }

  static func enterBackground() {
    os_log("백그라운드 진입")
    shared.enteredBackgroundDate = Date.now
  }

  static func enterForegroundScreen() {
    if shared.initialLoading == false {
      shared.initialLoading = true
      return
    }
    os_log("포그라운드 진입")
    reloadToken()
  }

  private static func reloadToken() {
    // 이전에 로그인한 이력이 있다면 토큰 리프레시 로직을 진행합니다.
    if SSTokenManager.shared.getUserID() != nil {
      Task {
        do {
          try await SSTokenInterceptor.shared.refreshTokenWithNetwork()
        } catch {
          let errorMessage = "Token refresh error with switching app\n" + error.localizedDescription
          NotificationCenter.default.post(name: SSNotificationName.logError, object: errorMessage)
        }
      }
    }
  }

  private static func resetApp() {
    defer {
      shared.enteredBackgroundDate = nil
    }
    guard let backgroundEnteredDate = shared.enteredBackgroundDate else {
      return
    }
    let interval = Date.now.timeIntervalSince(backgroundEnteredDate)

    if shared.timeoutInterval < Int(interval) {
      NotificationCenter.default.post(name: SSNotificationName.resetApp, object: nil)
    }
  }
}
