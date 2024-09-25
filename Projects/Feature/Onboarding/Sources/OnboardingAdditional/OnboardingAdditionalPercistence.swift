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
  static func saveToken(_ val: SignUpResponseDTO) throws {
    let token = SSToken(
      accessToken: val.accessToken,
      accessTokenExp: val.accessTokenExp,
      refreshToken: val.refreshToken,
      refreshTokenExp: val.refreshTokenExp
    )
    try SSTokenManager.shared.saveToken(token)
  }

  static func saveUserID(_ val: Int64) async throws {
    try SSTokenManager.shared.saveUserID(val)
  }
}
