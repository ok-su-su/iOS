//
//  OnboardingAdditionalPercistence.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SSPersistancy

enum OnboardingAdditionalPersistence {
  static func saveToken(_ val: SignUpResponseDTO) {
    let token = SSToken(
      accessToken: val.accessToken,
      accessTokenExp: val.accessTokenExp,
      refreshToken: val.refreshToken,
      refreshTokenExp: val.refreshTokenExp
    )
    do {
      try SSTokenManager.shared.saveToken(token)
    } catch {
      os_log("토큰 저장에 실패하였습니다.")
    }
  }
}
