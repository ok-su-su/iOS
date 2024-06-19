//
//  LaunchScreenHelper.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SSInterceptor
import SSNetwork
import SSPersistancy

struct LaunchScreenHelper {
  init() {}

  func runAppInitTask() async -> EndedLaunchScreenStatus {
    SSTokenManager.shared.removeToken()
    // 기존 유저인지 검사합니다.
    if !SSTokenManager.shared.isToken() {
      return .newUser
    }

    // refreshToken이 만료되었는지 검사합니다.
    if SSTokenManager.shared.isRefreshTokenExpired() {
      SSTokenManager.shared.removeToken()
      return .newUser
    }

    await SSTokenInterceptor.shared.refreshTokenWithNetwork()
    return .prevUser
  }
}
