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
  private static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  var searchFriendsByName: @Sendable (_ name: String) async throws -> [SentSearchItem]
  @Sendable private static func _searchFriendByName(name: String) async throws -> [SentSearchItem] {
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

  var requestSearchFriendsByAmount: @Sendable (_ amount: Int64) async throws -> [SentSearchItem]
  @Sendable private static func _requestSearchFriendsByAmount(_ amount: Int64) async throws -> [SentSearchItem] {
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider
      .request(
        .searchEnvelope(
          .init(
            types: [.SENT],
            include: [.CATEGORY, .FRIEND, .RELATIONSHIP],
            fromAmount: amount,
            toAmount: amount,
            size: 5
          )
        )
      )
    return data.data.compactMap { dto -> SentSearchItem? in
      guard let friendID = dto.friend?.id,
            let friendName = dto.friend?.name,
            let dateString = CustomDateFormatter.getYearAndMonthDateString(from: dto.envelope.handedOverAt),
            let relationshipName = dto.relationship?.relation
      else {
        return nil
      }
      return .init(id: friendID, title: friendName, firstContentDescription: relationshipName, secondContentDescription: dateString)
    }
  }

  var getEnvelopePropertyByID: @Sendable (_ id: Int64) async throws -> EnvelopeProperty?
}

// MARK: DependencyKey

extension SentSearchNetwork: DependencyKey {
  private enum SentSearchNetworkDefault {
    static let getEnvelopePropertyByID: (@Sendable (_ id: Int64) async throws -> EnvelopeProperty?) = { id in
      return try await SentMainNetwork.liveValue.requestSearchFriends(.init(friendIds: [id])).first
    }
  }

  static var liveValue: SentSearchNetwork = .init(
    searchFriendsByName: _searchFriendByName,
    requestSearchFriendsByAmount: _requestSearchFriendsByAmount,
    getEnvelopePropertyByID: SentSearchNetworkDefault.getEnvelopePropertyByID
  )

  enum Network: SSNetworkTargetType {
    case searchFriend(name: String?)
    case searchEnvelope(SearchEnvelopeURLParameter)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchFriend:
        "friends"
      case .searchEnvelope:
        "envelopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchFriend:
        .get
      case .searchEnvelope:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchFriend(name: name):
        if let name {
          return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        }
        return .requestPlain
      case let .searchEnvelope(searchEnvelopeURLParameter):
        return .requestParameters(
          parameters: searchEnvelopeURLParameter.makeParameter(),
          encoding: URLEncoding(arrayEncoding: .noBrackets)
        )
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
