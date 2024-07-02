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
import SSSearch

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
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.searchFriend(name: nil))
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
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.searchFriend(name: val))
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
    let data: PageResponseDtoSearchFriendResponse = try await provider.request(.searchFriend(name: name))
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

// MARK: - SentSearchItem

struct SentSearchItem: SSSearchItemable, Hashable, Codable {
  /// 친구의 아이디 입니다.
  var id: Int64
  /// 친구의 이름 입니다.
  var title: String
  /// 경조사 이름 입니다.
  var firstContentDescription: String?
  /// 날짜 이름 입니다.
  var secondContentDescription: String?
}
