//
//  MyPageMainNetwork.swift
//  MyPage
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - MyPageMainNetwork

struct MyPageMainNetwork: Sendable {
  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  private nonisolated(unsafe) static let appStoreNetworkProvider = MoyaProvider<AppstoreNetwork>()

  var getMyInformation: @Sendable () async throws -> UserInfoResponse
  private static func _getMyInformation() async throws -> UserInfoResponse {
    return try await provider.request(.myPageInformation)
  }

  var updateUserInformation: @Sendable (_ userID: Int64, _ body: UpdateUserProfileRequestBody) async throws -> UserInfoResponse
  private static func _updateUserInformation(userID: Int64, requestBody: UpdateUserProfileRequestBody) async throws -> UserInfoResponse {
    return try await provider.request(.updateMyProfile(userID: userID, body: requestBody))
  }

  var logout: @Sendable () async throws -> Void
  @Sendable private static func _logout() async throws {
    try await provider.request(.logout)
  }

  var resign: @Sendable () async throws -> Void
  @Sendable private static func _resign() async throws {
    try await provider.request(.withdraw)
  }

  var getAppstoreVersion: @Sendable () async throws -> String?
  @Sendable private static func _getAppstoreVersion() async throws -> String? {
    let data = try await appStoreNetworkProvider.request(.getSUSUAppstoreVersion)
    let jsonObject = try JSONSerialization.jsonObject(with: data)
    guard let json = jsonObject as? [String: Any],
          let results = json["results"] as? [[String: Any]],
          let firstResult = results.first,
          let currentVersion = firstResult["version"] as? String
    else {
      return nil
    }
    return currentVersion
  }

  var resignWithApple: @Sendable (_ identity: String?) async throws -> Void
  @Sendable private static func _resignWithApple(identity: String?) async throws {
    guard let identity else {
      throw NSError(domain: "No apple IdentityToken its fatal error", code: 30)
    }
    try await provider.request(.withdrawApple(identityToken: identity))
  }

  var downloadExcel: @Sendable () async throws -> Data
  @Sendable private static func _downloadExcel() async throws -> Data {
    let data: Data = try await provider.request(.downloadExcel)
    return data
  }
}

extension DependencyValues {
  var myPageMainNetwork: MyPageMainNetwork {
    get { self[MyPageMainNetwork.self] }
    set { self[MyPageMainNetwork.self] = newValue }
  }
}

// MARK: - MyPageMainNetwork + DependencyKey

extension MyPageMainNetwork: DependencyKey {
  static let liveValue: MyPageMainNetwork = .init(
    getMyInformation: _getMyInformation,
    updateUserInformation: _updateUserInformation,
    logout: _logout,
    resign: _resign,
    getAppstoreVersion: _getAppstoreVersion,
    resignWithApple: _resignWithApple,
    downloadExcel: _downloadExcel
  )

  private enum AppstoreNetwork: TargetType {
    case getSUSUAppstoreVersion
    var baseURL: URL {
      .init(string: "https://itunes.apple.com/lookup?bundleId=com.oksusu.susu.app")!
    }

    var path: String { "" }

    var method: Moya.Method {
      .get
    }

    var task: Moya.Task {
      .requestPlain
    }

    var headers: [String: String]? { nil }
  }

  private enum Network: SSNetworkTargetType {
    case myPageInformation
    case updateMyProfile(userID: Int64, body: UpdateUserProfileRequestBody)
    case logout
    case withdraw
    case withdrawApple(identityToken: String)
    case downloadExcel

    var additionalHeader: [String: String]? { return nil }
    var path: String {
      switch self {
      case .myPageInformation:
        "users/my-info"
      case let .updateMyProfile(userID: userID, _):
        "users/\(userID.description)"
      case .logout:
        "auth/logout"
      case .withdraw,
           .withdrawApple:
        "auth/withdraw"
      case .downloadExcel:
        "excel/all-envelopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .myPageInformation:
        .get
      case .updateMyProfile:
        .patch
      case .logout:
        .post
      case .withdraw,
           .withdrawApple:
        .post
      case .downloadExcel:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case .logout,
           .myPageInformation:
        .requestPlain
      case let .updateMyProfile(_, body: body):
        .requestData(body.getBody())
      case .withdraw:
        .requestPlain
      case let .withdrawApple(token):
        .requestParameters(parameters: ["appleAccessToken": token], encoding: URLEncoding.queryString)
      case .downloadExcel:
        .requestPlain
      }
    }
  }
}
