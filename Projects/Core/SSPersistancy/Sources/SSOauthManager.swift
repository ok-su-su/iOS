//
//  SSOauthManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 7/16/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SSOAuthManager

public final class SSOAuthManager: Sendable {
  private static let shared = SSOAuthManager()
  private init() {}

  public static func getOAuthType() -> OAuthType? {
    guard let data = SSKeychain.shared.load(key: key),
          let rawValue = String(data: data, encoding: .utf8),
          let type = OAuthType(rawValue: rawValue)
    else {
      return .none
    }
    return type
  }

  public static func setOAuthType(_ type: OAuthType) {
    guard let data = type.rawValue.data(using: .utf8) else {
      return
    }
    SSKeychain.shared.save(key: Self.key, data: data)
  }

  private static let key = String(describing: OAuthType.self)
}

// MARK: - OAuthType

public enum OAuthType: String {
  case APPLE
  case KAKAO
  case GOOGLE
}
