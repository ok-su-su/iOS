//
//  CreateEnvelopeNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - CreateEnvelopeNetwork

struct CreateEnvelopeNetwork: Equatable {
  static func == (_: CreateEnvelopeNetwork, _: CreateEnvelopeNetwork) -> Bool { true }

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  func findIDIfExistPrev(name: String, relationID: Int) async throws -> Int64? {
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.findFriend(name))
    // 검색후에 relationID가 똑같은 경우가 있다면 ID를 리턴합니다.
    return data.data.filter { $0.relationship.id == relationID }.first?.friend.id
  }

  /// FriendID를 가져옵니다.
  func getFriendID(_ bodyProperty: CreateFriendRequestBody) async throws -> Int64 {
    if let name = bodyProperty.name,
       let relationID = bodyProperty.relationshipId,
       // 만약 사용자가 입력한 이름과 관계가 서버에 존재하는경우 이전 아이디를 리턴합니다.
       let id = try await findIDIfExistPrev(name: name, relationID: relationID) {
      return id
    }
    // 만약 사용자가 입력한 이름과 관계가 서버에 존재하지 않는 경우 새 friendID를 만듭니다.
    return try await createFriend(bodyProperty)
  }

  func createFriend(_ bodyProperty: CreateFriendRequestBody) async throws -> Int64 {
    let data: CreateFriendResponseDTO = try await provider.request(.createFriend(bodyProperty))
    os_log("친구 생성에 성공하였습니다. \(#function)")
    return data.id
  }

  func createEnvelope(_ bodyProperty: CreateEnvelopeRequestBody) async throws {
    try await provider.request(.createEnvelope(bodyProperty))
    os_log("봉투 생성에 성공하였습니다. \(#function)")
  }
}

extension DependencyValues {
  var createEnvelopeNetwork: CreateEnvelopeNetwork {
    get { self[CreateEnvelopeNetwork.self] }
    set { self[CreateEnvelopeNetwork.self] = newValue }
  }
}

// MARK: - CreateEnvelopeNetwork + DependencyKey

extension CreateEnvelopeNetwork: DependencyKey {
  static var liveValue: CreateEnvelopeNetwork = .init()
  enum Network: SSNetworkTargetType {
    case createFriend(CreateFriendRequestBody)
    case findFriend(String)
    case createEnvelope(CreateEnvelopeRequestBody)

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .createFriend,
           .findFriend:
        "friends"
      case .createEnvelope:
        "envelopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .createEnvelope,
           .createFriend:
        return .post
      case .findFriend:
        return .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .createFriend(bodyProperty):
        return .requestData(bodyProperty.getData())
      case let .findFriend(name):
        return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
      case let .createEnvelope(bodyProperty):
        return .requestData(bodyProperty.getData())
      }
    }
  }
}

// MARK: - CreateFriendResponseDTO

struct CreateFriendResponseDTO: Decodable, Equatable {
  let id: Int64
  enum CodingKeys: CodingKey {
    case id
  }
}
