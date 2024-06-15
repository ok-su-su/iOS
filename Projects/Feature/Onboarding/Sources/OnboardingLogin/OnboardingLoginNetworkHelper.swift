//
//  OnboardingLoginNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import KakaoLogin

struct OnboardingLoginNetworkHelper: Equatable {
  func loginWithKakao() async -> Bool {
    return await LoginWithKakao.loginWithKakao()
  }

  init() {}
}
