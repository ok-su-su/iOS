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

// MARK: - CreateEnvelopeNameNetwork

struct CreateEnvelopeNameNetwork {
  var searchFriendByName: @Sendable (_ name: String) async throws -> [SearchFriendItem]
  @Sendable static func _searchFriendByName(_ val: String) async throws -> [SearchFriendItem] {
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.searchFriend(name: val))
    return data.data.compactMap { dto -> SearchFriendItem? in
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
}

// MARK: DependencyKey

extension CreateEnvelopeNameNetwork: DependencyKey {
  static var liveValue: CreateEnvelopeNameNetwork = .init(
    searchFriendByName: _searchFriendByName
  )
  static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

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
  var createEnvelopeNameNetwork: CreateEnvelopeNameNetwork {
    get { self[CreateEnvelopeNameNetwork.self] }
    set { self[CreateEnvelopeNameNetwork.self] = newValue }
  }
}
