//
//  RefreshTokenTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import OSLog
import SSNetwork

// MARK: - RefreshTokenTargetType

public struct RefreshTokenTargetType: SSNetworkTargetType {
  public init(bodyData: Data) {
    self.bodyData = bodyData
  }

  public let bodyData: Data

  public var additionalHeader: [String: String]? = nil

  public var path: String = "auth/token/refresh"

  public var method: Moya.Method = .post

  public var task: Moya.Task {
    .requestCompositeData(bodyData: bodyData, urlParameters: [:])
  }
}

// MARK: - RefreshResponseDTO

struct RefreshResponseDTO: Decodable {
  var accessToken: String
  var refreshToken: String
  var accessTokenExp: String
  var refreshTokenExp: String

  func getAccessTokenData() throws -> Data {
    let res = accessToken.data(using: .utf8)
    guard let res else {
      throw TokenNetworkingError.stringToDataConvertingError("AccessToken")
    }
    return res
  }

  func getRefreshTokenData() throws -> Data {
    let res = refreshToken.data(using: .utf8)
    guard let res else {
      throw TokenNetworkingError.stringToDataConvertingError("refreshToken")
    }
    return res
  }
}

// MARK: - TokenNetworkingError

enum TokenNetworkingError: LocalizedError {
  case noSavedToken
  case stringToDataConvertingError(String)

  var errorDescription: String? {
    switch self {
    case .noSavedToken:
      return "저장된 토큰이 없습니다. 인터셉터를 활용하지 않아야 합니다. "
    case let .stringToDataConvertingError(val):
      return "\(val) 을 데이터 화 하는데에 실패했습니다."
    }
  }
}

// MARK: - RefreshRequestBodyDTO

struct RefreshRequestBodyDTO: Encodable {
  var accessToken: String
  var refreshToken: String
  init(_ accessToken: String, _ refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
