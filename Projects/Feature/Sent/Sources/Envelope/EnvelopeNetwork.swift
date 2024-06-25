//
//  EnvelopeNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

extension DependencyValues {
  var envelopeNetwork: EnvelopeNetwork {
    get { self[EnvelopeNetwork.self] }
    set { self[EnvelopeNetwork.self] = newValue }
  }
}

// MARK: - EnvelopeNetwork

struct EnvelopeNetwork: Equatable, DependencyKey {
  static var liveValue: EnvelopeNetwork = .init()
  static func == (_: EnvelopeNetwork, _: EnvelopeNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case searchLatestOfThreeEnvelope(friendID: Int)
    case searchEnvelope(friendID: Int, page: Int)

    var additionalHeader: [String: String]? { nil }
    var path: String { "envelopes" }
    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case let .searchLatestOfThreeEnvelope(friendID):
        return .requestParameters(
          parameters: [
            "friendIds": friendID,
            "size": 3,
            "include": "FRIEND,RELATIONSHIP,CATEGORY",
          ],
          encoding: URLEncoding.queryString
        )
      case let .searchEnvelope(friendID: friendID, page: page):
        return .requestParameters(
          parameters: [
            "friendIds": friendID,
            "size": 15,
            "include": "FRIEND,RELATIONSHIP,CATEGORY",
            "page": page,
          ],
          encoding: URLEncoding.queryString
        )
      }
    }
  }

  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelope(friendID: Int, page: Int) async throws -> [EnvelopeContent] {
    let data: SearchLatestOfThreeEnvelopeResponseDTO = try await provider.request(.searchEnvelope(friendID: friendID, page: page))
    return data.data.map { $0.toEnvelopeContent() }
  }

  func getEnvelope(id: Int) async throws -> [EnvelopeContent] {
    let data: SearchLatestOfThreeEnvelopeResponseDTO = try await provider.request(.searchLatestOfThreeEnvelope(friendID: id))
    return data.data.map { $0.toEnvelopeContent() }
  }
}

// MARK: - SearchLatestOfThreeEnvelopeResponseDTO

struct SearchLatestOfThreeEnvelopeResponseDTO: Decodable {
  let data: [SearchLatestOfThreeEnvelopeDataResponseDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortResponseDTO
}

// MARK: - SearchLatestOfThreeEnvelopeDataResponseDTO

struct SearchLatestOfThreeEnvelopeDataResponseDTO: Decodable {
  let envelope: SearchEnvelopeResponseEnvelopeDTO
  let category: SearchEnvelopeResponseCategoryDTO
  let relationship: SearchEnvelopeResponseRelationshipDTO
  let friend: SearchEnvelopeResponseFriendDTO
}

extension SearchLatestOfThreeEnvelopeDataResponseDTO {
  func toEnvelopeContent() -> EnvelopeContent {
    return .init(
      id: envelope.id,
      dateText: CustomDateFormatter.getYearAndMonthDateString(from: envelope.handedOverAt) ?? "",
      eventName: relationship.relation,
      envelopeType: envelope.type == "SENT" ? .sent : .receive,
      price: envelope.amount
    )
  }
}
