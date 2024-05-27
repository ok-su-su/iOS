//
//  TokenRefreshRequest.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct TokenRefreshRequest: Encodable {
  private enum CodingKeys: String, CodingKey {
    case accessToken
    case refreshToken
  }
  public var accessToken: String
  public var refreshToken: String
  
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
