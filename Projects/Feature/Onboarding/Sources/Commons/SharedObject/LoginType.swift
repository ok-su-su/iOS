//
//  LoginType.swift
//  Onboarding
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSPersistancy

enum LoginType: String, Equatable, Encodable {
  case KAKAO
  case APPLE
  case GOOGLE

  var OAuthType: OAuthType {
    switch self {
    case .KAKAO:
      .KAKAO
    case .APPLE:
      .APPLE
    case .GOOGLE:
      .GOOGLE
    }
  }
}
