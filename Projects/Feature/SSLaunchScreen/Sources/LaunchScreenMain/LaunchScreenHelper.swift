//
//  LaunchScreenHelper.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import OSLog
import SSInterceptor
import SSNetwork
import SSNotification
import SSPersistancy

// MARK: - LaunchScreenTokenNetwork

struct LaunchScreenTokenNetwork: Sendable {
  var checkTokenValid: @Sendable () async -> EndedLaunchScreenStatus
  @Sendable private static func _checkTokenValid() async -> EndedLaunchScreenStatus {
    // 기존 유저인지 검사합니다.
    if !SSTokenManager.shared.isToken() {
      return .newUser
    }

    // refreshToken이 만료되었는지 검사합니다.
    if SSTokenManager.shared.isRefreshTokenExpired() {
      return newUserRoutine()
    }
    // 토큰을 리프래시 합니다.
    do {
      try await SSTokenInterceptor.shared.refreshTokenWithNetwork()
      os_log("토큰 갱신에 성공하였습니다.")

      // 버전이 추가되면서 새로운 로직입니다.
      await prevUserNewFeature1_0_5()

      return .prevUser
    } catch {
      NotificationCenter.default.post(name: SSNotificationName.logError, object: error)
      return newUserRoutine()
    }
  }

  /// 1.0.5 버전에 ACCESSTOKEN에 관한 로직입니다.
  @Sendable private static func prevUserNewFeature1_0_5() async {
    // 만약 USERID가 없을 경우에 로직을 실행합니다.
    if SSTokenManager.shared.getUserID() == nil {
      try? await SSTokenInterceptor.shared.setUserNameByAccessToken()
      os_log("유저 아이디 저장에 성공하였습니다.")
    }
  }

  private static func newUserRoutine() -> EndedLaunchScreenStatus {
    SSTokenManager.shared.removeToken()
    return .newUser
  }
}

// MARK: DependencyKey

extension LaunchScreenTokenNetwork: DependencyKey {
  static let liveValue: LaunchScreenTokenNetwork = .init(checkTokenValid: _checkTokenValid)
}

extension DependencyValues {
  var launchScreenTokenNetwork: LaunchScreenTokenNetwork {
    get { self[LaunchScreenTokenNetwork.self] }
    set { self[LaunchScreenTokenNetwork.self] = newValue }
  }
}
