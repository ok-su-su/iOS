//
//  SSTokenManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

// MARK: - SSTokenManager

public final class SSTokenManager {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let isoFormatter = ISO8601DateFormatter()
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

  public func isToken() -> Bool {
    guard let tokenData = SSKeychain.shared.load(key: String(describing: SSToken.self)) else {
      return false
    }
    return true
  }

  public func isAccessTokenExpired() -> Bool {
    do {
      let token = try getToken()

      guard let accessTokenExp = isoFormatter.date(from: token.accessTokenExp) else {
        throw SSTokenManagerError.cantConvertingTokenStringToDate
      }
      return Date.now > accessTokenExp
    } catch {
      os_log("\(error.localizedDescription)")
      return false
    }
  }

  public func isRefreshTokenExpired() -> Bool {
    do {
      let token = try getToken()
      let isoFormatter = ISO8601DateFormatter()
      guard let refreshTokenExp = isoFormatter.date(from: token.refreshTokenExp) else {
        throw SSTokenManagerError.cantConvertingTokenStringToDate
      }
      return Date.now > refreshTokenExp
    } catch {
      os_log("\(error.localizedDescription)")
      return false
    }
  }

  public func removeToken() {
    SSKeychain.shared.delete(key: String(describing: SSToken.self))
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
  case cantConvertingTokenStringToDate

  var errorDescription: String? {
    switch self {
    case .emptyToken:
      return "토큰이 저장되지 않았습니다."
    case .invalidToken:
      return "토큰이 유효하지 않습니다."
    case .cantConvertingTokenStringToDate:
      return "서버에서 받은 String Token을 저장할 수 없습니다."
    }
  }
}

// MARK: - SSToken

public struct SSToken: Codable {
  public let accessToken: String
  public let accessTokenExp: String
  public let refreshToken: String
  public let refreshTokenExp: String

  public init(accessToken: String, accessTokenExp: String, refreshToken: String, refreshTokenExp: String) {
    self.accessToken = accessToken
    self.accessTokenExp = accessTokenExp
    self.refreshToken = refreshToken
    self.refreshTokenExp = refreshTokenExp
  }
}
