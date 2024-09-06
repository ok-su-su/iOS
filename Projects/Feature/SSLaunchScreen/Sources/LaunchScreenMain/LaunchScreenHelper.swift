//
//  LaunchScreenHelper.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Dependencies
import SSInterceptor
import SSNetwork
import SSPersistancy
import OSLog

struct LaunchScreenTokenNetwork {
  var checkTokenValid: () async -> EndedLaunchScreenStatus
  static func _checkTokenValid() async -> EndedLaunchScreenStatus {
    // 기존 유저인지 검사합니다.
    if !SSTokenManager.shared.isToken() {
      return .newUser
    }

    // refreshToken이 만료되었는지 검사합니다.
    if SSTokenManager.shared.isRefreshTokenExpired() {
      return newUserRoutine()
    }

    do {
      try await SSTokenInterceptor.shared.isValidToken()
      try await SSTokenInterceptor.shared.refreshTokenWithNetwork()
      os_log("토큰 갱신에 성공하였습니다.")
      return .prevUser
    } catch {
      os_log("\(error.localizedDescription)")
      return newUserRoutine()
    }
  }

  private static func newUserRoutine() -> EndedLaunchScreenStatus {
    SSTokenManager.shared.removeToken()
    return .newUser
  }
}

extension LaunchScreenTokenNetwork: DependencyKey {
  static var liveValue: LaunchScreenTokenNetwork = .init(checkTokenValid: _checkTokenValid)
}

extension DependencyValues {
  var launchScreenTokenNetwork: LaunchScreenTokenNetwork {
    get { self[LaunchScreenTokenNetwork.self ]}
    set { self[LaunchScreenTokenNetwork.self] = newValue}
  }
}
