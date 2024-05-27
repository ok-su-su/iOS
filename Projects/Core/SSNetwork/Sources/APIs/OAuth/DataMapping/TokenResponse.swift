//
//  TokenResponse.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct TokenResponse: Decodable {
  private enum CodingKeys: String, CodingKey {
    case accessToken
    case accessTokenExp
    case refreshToken
    case refreshTokenExp
  }
  public var accessToken: String
  public var accessTokenExp: String
  public var refreshToken: String
  public var refreshTokenExp: String
}
