//
//  SSTokenManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SSNotification

// MARK: - SSTokenManager

public final class SSTokenManager: Sendable {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let isoFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()

  /// expString의 Mili초를 제거하고 초 까지만 사용할 수 있게 string을 조작합니다.
  /// - Parameter val: "DateString입니다. yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS...
  /// - Returns: yyyy-MM-dd'T'HH:mm:ss의 String을 리턴합니다.
  ///
  /// ex) 2024-09-17T17:27:02.142157075 -> 2024-09-17T17:27:02
  func truncatedDateString(_ val: String) -> String {
    String(val.prefix(19))
  }

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
    return SSKeychain.shared.load(key: String(describing: SSToken.self)) != nil
  }

  public func isAccessTokenExpired() -> Bool {
    do {
      let token = try getToken()
      let accessTokenExpString = truncatedDateString(token.accessTokenExp)
      guard let accessTokenExp = isoFormatter.date(from: accessTokenExpString) else {
        throw SSTokenManagerError.cantConvertingTokenStringToDate("AccessTokenExp: \(token.accessTokenExp)")
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
      let refreshTokenExpString = truncatedDateString(token.refreshTokenExp)
      guard let refreshTokenExp = isoFormatter.date(from: refreshTokenExpString) else {
        throw SSTokenManagerError.cantConvertingTokenStringToDate("RefreshTokenExp: \(token.refreshTokenExp)")
      }
      return Date.now > refreshTokenExp
    } catch {
      NotificationCenter.default.post(name: SSNotificationName.logError, object: error)
      return true
    }
  }

  public func removeToken() {
    SSKeychain.shared.delete(key: String(describing: SSToken.self))
  }

  private let userIDKey: String = "SUSU_USER_ID"
  public func saveUserID(_ val: Int64) throws {
    let dataOfUserID = try encoder.encode(val)
    SSKeychain.shared.save(key: userIDKey, data: dataOfUserID)
  }

  public func getUserID() -> Int64? {
    guard let userIDData = SSKeychain.shared.load(key: userIDKey)
    else {
      return nil
    }
    let userID = try? decoder.decode(Int64.self, from: userIDData)
    return userID
  }

  public func removeUserID() {
    SSKeychain.shared.delete(key: userIDKey)
  }

  public func removeCurrentUserInformation() {
    removeUserID()
    removeToken()
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
  case cantConvertingTokenStringToDate(String)

  var errorDescription: String? {
    switch self {
    case .emptyToken:
      return "토큰이 저장되지 않았습니다."
    case .invalidToken:
      return "토큰이 유효하지 않습니다."
    case let .cantConvertingTokenStringToDate(message):
      return "서버에서 받은 String Token을 Date타입으로 변경할 수 없습니다.\n\(message)"
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
