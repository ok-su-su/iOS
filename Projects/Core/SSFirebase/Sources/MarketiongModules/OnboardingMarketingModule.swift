//
//  OnboardingMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - OnboardingMarketingModule

public enum OnboardingMarketingModule: CustomStringConvertible, Equatable {
  case initialVote
  case login
  case agreeToTerms
  case termDetail
  case registerName
  case additional
  public var description: String {
    switch self {
    case .initialVote:
      "시작 투표"
    case .login:
      "로그인"
    case .agreeToTerms:
      "약관동의"
    case .termDetail:
      "서비스 이용약관, 개인정보 수집안내"
    case .registerName:
      "이름 등록"
    case .additional:
      "추가 정보 등록"
    }
  }
}
