//
//  EnvelopeNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - EnvelopeNetwork

struct EnvelopeNetwork: Equatable {
  static func == (_: EnvelopeNetwork, _: EnvelopeNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case searchLatestOfThreeEnvelope(friendID: Int)

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
      }
    }
  }

  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelope(id: Int) async throws -> [EnvelopeContent] {
    let data: SearchLatestOfThreeEnvelopeResponseDTO = try await provider.request(.searchLatestOfThreeEnvelope(friendID: id))

    return data.data.map {
      .init(
        dateText: CustomDateFormatter.getYearAndMonthDateString(from: $0.envelope.handedOverAt) ?? "",
        eventName: $0.relationship.relation,
        envelopeType: $0.envelope.type == "SENT" ? .sent : .receive,
        price: $0.envelope.amount
      )
    }
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
