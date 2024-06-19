//
//  SSTokenManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SSTokenManager

public final class SSTokenManager {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  public func saveToken(_ dto: SSToken) throws {
    let data = try encoder.encode(dto)
    SSKeychain.shared.save(key: String(describing: SSToken.self), data: data)
  }

  public static let shared = SSTokenManager()

  public func getToken() throws -> SSToken {
    guard let tokenData = SSKeychain.shared.load(key: String(describing: SSToken.self)) else {
      throw SSTokenManagerError.emptyToken
    }

    let token = try decoder.decode(SSToken.self, from: tokenData)
    return token
  }

  private init() {}

  private enum Constants: String {
    case accessToken
    case accessTokenExp
    case refreshToken
    case refreshTokenExp
  }
}

// MARK: - SSTokenManagerError

enum SSTokenManagerError: LocalizedError {
  case emptyToken
  case invalidToken

  var errorDescription: String? {
    switch self {
    case .emptyToken:
      return "토큰이 저장되지 않았습니다."
    case .invalidToken:
      return "토큰이 유효하지 않습니다."
    }
  }
}

// MARK: - SSToken

public struct SSToken: Codable {
  let accessToken: String
  let accessTokenExp: String
  let refreshToken: String
  let refreshTokenExp: String

  public init(accessToken: String, accessTokenExp: String, refreshToken: String, refreshTokenExp: String) {
    self.accessToken = accessToken
    self.accessTokenExp = accessTokenExp
    self.refreshToken = refreshToken
    self.refreshTokenExp = refreshTokenExp
  }
}
