//
//  OnboardingTarget.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

enum OnboardingTarget {
  case onboarding
}

extension OnboardingTarget: BaseTargetType {
  
  var path: String {
    switch self {
    case .onboarding:
      return "/votes/onboarding"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .onboarding:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .onboarding:
      return .requestPlain
    }
  }
  
}
