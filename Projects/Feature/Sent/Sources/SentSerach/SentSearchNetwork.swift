//
//  SentSearchNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - SentSearchNetwork

struct SentSearchNetwork {
  @Dependency(\.sentMainNetwork) var searchAmountEnvelopeNetwork
  @Dependency(\.sentMainNetwork) var searchEnvelopeNetwork

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func searchFriendsBy(name: String) async throws -> [SentSearchItem] {
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.searchFriend(name: name))
    return data.data.compactMap { dto -> SentSearchItem? in
      guard let targetDate = CustomDateFormatter.getYearAndMonthDateString(from: dto.recentEnvelope?.handedOverAt)
      else {
        return nil
      }
      return .init(
        id: dto.friend.id,
        title: dto.friend.name,
        firstContentDescription: dto.recentEnvelope?.category,
        secondContentDescription: targetDate
      )
    }
  }

  func searchEnvelopeBy(amount: Int64) async throws -> [SentSearchItem] {
    return try await searchAmountEnvelopeNetwork.requestSearchFriends(amount)
  }

  func getEnvelopePropertyBy(id: Int64) async throws -> EnvelopeProperty? {
    try await searchEnvelopeNetwork.requestSearchFriends(SearchFriendsParameter(friendIds: [id])).first
  }
}

// MARK: DependencyKey

extension SentSearchNetwork: DependencyKey {
  static var liveValue: SentSearchNetwork = .init()

  enum Network: SSNetworkTargetType {
    case searchFriend(name: String?)

    var additionalHeader: [String: String]? { nil }
    var path: String { "friends" }
    var method: Moya.Method {
      switch self {
      case .searchFriend:
        return .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchFriend(name: name):
        if let name {
          return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        }
        return .requestPlain
      }
    }
  }
}

extension DependencyValues {
  var sentSearchNetwork: SentSearchNetwork {
    get { self[SentSearchNetwork.self] }
    set { self[SentSearchNetwork.self] = newValue }
  }
}

// MARK: - SearchFriendResponse

struct SearchFriendResponse: Codable {
  let friend: FriendModel
  let relationship: RelationshipInfoModel
  let recentEnvelope: RecentEnvelopeModel?
  enum CodingKeys: CodingKey {
    case friend
    case relationship
    case recentEnvelope
  }
}

// MARK: - FriendModel

struct FriendModel: Codable {
  let id: Int64
  let name: String
  let phoneNumber: String?
  enum CodingKeys: CodingKey {
    case id
    case name
    case phoneNumber
  }
}

// MARK: - RecentEnvelopeModel

struct RecentEnvelopeModel: Codable {
  let category, handedOverAt: String
  enum CodingKeys: CodingKey {
    case category
    case handedOverAt
  }
}

// MARK: - RelationshipInfoModel

struct RelationshipInfoModel: Codable {
  let id: Int
  let relation: String
  let customRelation: String?
  let description: String?
  enum CodingKeys: CodingKey {
    case id
    case relation
    case customRelation
    case description
  }
}

