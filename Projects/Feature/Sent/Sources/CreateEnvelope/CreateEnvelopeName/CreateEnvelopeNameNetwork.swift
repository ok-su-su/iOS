//
//  CreateEnvelopeNameNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

extension DependencyValues {
  var createEnvelopeNameNetwork: CreateEnvelopeNameNetwork {
    get { self[CreateEnvelopeNameNetwork.self] }
    set { self[CreateEnvelopeNameNetwork.self] = newValue }
  }
}

// MARK: - CreateEnvelopeNameNetwork

struct CreateEnvelopeNameNetwork: Equatable, DependencyKey {
  static var liveValue: CreateEnvelopeNameNetwork = .init()
  static func == (_: CreateEnvelopeNameNetwork, _: CreateEnvelopeNameNetwork) -> Bool {
    return true
  }

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

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func searchInitialEnvelope() async throws -> [PrevEnvelope] {
    let data: SearchFriendsByNameResponseDTO = try await provider.request(.searchFriend(name: nil))
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
        eventDate: targetDate
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
        eventDate: targetDate
      )
    }
  }

  func searchFriendBy(name: String) async throws -> [SentSearchItem] {
    let data: SearchFriendsByNameResponseDTO = try await provider.request(.searchFriend(name: name))
    return data.data.compactMap { dto -> SentSearchItem? in
      guard let recentEnvelope = dto.recentEnvelope,
            let targetDate = CustomDateFormatter.getYearAndMonthDateString(from: dto.recentEnvelope?.handedOverAt)
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
}

// MARK: - SearchFriendsByNameResponseDTO

struct SearchFriendsByNameResponseDTO: Codable, Equatable {
  let data: [SearchFriendsByNameDataResponseDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortResponseDTO

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
