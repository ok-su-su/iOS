//
//  OnboardingLoginPersistence.swift
//  Onboarding
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import AppleLogin
import Dependencies
import Foundation
import KakaoLogin

// MARK: - OnboardingLoginPersistence

final class OnboardingLoginPersistence: DependencyKey {
  static var liveValue: OnboardingLoginPersistence = .init()

  func getToken(_ type: LoginType) -> String? {
    switch type {
    case .KAKAO:
      return LoginWithKakao.getToken()
    case .APPLE:
      return LoginWithApple.identityToken
    case .GOOGLE:
      fatalError("로그인 방식이 구현되지 않았습니다.")
    }
  }
}

extension DependencyValues {
  var loginTokenManager: OnboardingLoginPersistence {
    get { self[OnboardingLoginPersistence.self] }
    set { self[OnboardingLoginPersistence.self] = newValue }
  }
}
