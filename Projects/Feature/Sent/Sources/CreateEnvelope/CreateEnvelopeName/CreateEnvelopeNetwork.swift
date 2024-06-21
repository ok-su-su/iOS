//
//  CreateEnvelopeNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - CreateEnvelopeNetwork

struct CreateEnvelopeNetwork: Equatable {
  static func == (_: CreateEnvelopeNetwork, _: CreateEnvelopeNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case searchFriend(name: String?)
    var additionalHeader: [String: String]? { nil }
    var path: String { "friends" }

    var method: Moya.Method {
      switch self {
      case let .searchFriend(name):
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

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func searchInitialEnvelope() async throws -> [PrevEnvelope] {
    let data: SearchFriendsByNameResponseDTO = try await provider.request(.searchFriend(name: nil))
    return data.data.compactMap { dto -> PrevEnvelope? in
      guard let recentEnvelope = dto.recentEnvelope else {
        return nil
      }
      return .init(
        name: dto.friend.name,
        relationShip: dto.relationship.relation,
        eventName: recentEnvelope.category,
        //      eventDate: $0.recentEnvelope.handedOverAt
        eventDate: .now
      )
    }
  }

  func searchPrevName(_ val: String) async throws -> [PrevEnvelope] {
    let data: SearchFriendsByNameResponseDTO = try await provider.request(.searchFriend(name: val))
    return data.data.compactMap { dto -> PrevEnvelope? in
      guard let recentEnvelope = dto.recentEnvelope,
            let targetDate = CustomDateFormatter.getDate(from: recentEnvelope.handedOverAt)
      else {
        return nil
      }
      return .init(
        name: dto.friend.name,
        relationShip: dto.relationship.relation,
        eventName: recentEnvelope.category,
        //      eventDate: $0.recentEnvelope.handedOverAt
        eventDate: targetDate
      )
    }
  }
}

// MARK: - SearchFriendsByNameResponseDTO

struct SearchFriendsByNameResponseDTO: Codable, Equatable {
  let data: [SearchFriendsByNameDataResponseDTO]
  let page: Int
  let size: Int
  let totalPage: Int
  let totalCount: Int
  let sort: SearchEnvelopeResponseSortDTO

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchFriendsByNameDataResponseDTO

struct SearchFriendsByNameDataResponseDTO: Codable, Equatable {
  var friend: SearchFriendsFriendResponseDTO
  var relationship: SearchEnvelopeResponseRelationshipDTO
  var recentEnvelope: SearchFriendsRecentEnvelopeResponseDTO?

  enum CodingKeys: String, CodingKey {
    case friend
    case relationship
    case recentEnvelope
  }
}

// MARK: - SearchFriendsRecentEnvelopeResponseDTO

struct SearchFriendsRecentEnvelopeResponseDTO: Codable, Equatable {
  let category: String
  let handedOverAt: String

  enum CodingKeys: String, CodingKey {
    case category
    case handedOverAt
  }
}
