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

final class MyPageMainNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  private let networkProvider = MoyaProvider<AppstoreNetwork>()

  func getMyInformation() async throws -> UserInfoResponseDTO {
    return try await provider.request(.myPageInformation)
  }

  func updateUserInformation(userID: Int64, requestBody: UpdateUserProfileRequestBody) async throws -> UserInfoResponseDTO {
    return try await provider.request(.updateMyProfile(userID: userID, body: requestBody))
  }

  func logout() async throws {
    try await provider.request(.logout)
  }

  func resign() async throws {
    try await provider.request(.withdraw)
  }

  func getAppstoreVersion() async throws -> String? {
    let data = try await networkProvider.request(.getSUSUAppstoreVersion)
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

  func resignWithApple(identity: String?) async throws {
    guard let identity else {
      throw NSError(domain: "No apple IdentityToken its fatal error", code: 30)
    }
    try await provider.request(.withdrawApple(identityToken: identity))
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
  static var liveValue: MyPageMainNetwork = .init()

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
      }
    }
  }
}

// MARK: - UserInfoResponseDTO

struct UserInfoResponseDTO: Equatable, Decodable {
  /// 내 아이디
  let id: Int64
  /// 내 이름
  let name: String
  /// 성별 M: 남자, W 여자
  let gender: String?
  /// 출생 년도
  let birth: Int?
}

// MARK: - UpdateUserProfileRequestBody

struct UpdateUserProfileRequestBody: Encodable {
  let name: String
  /// 성별 M: 남자, W 여자
  let gender: String?
  /// 출생 년도
  let birth: Int?

  func getBody() -> Data {
    do {
      return try JSONEncoder().encode(self)
    } catch {
      os_log("UpdateUserProfileRequestBody Encode 실패했습니다.")
      return Data()
    }
  }
}
