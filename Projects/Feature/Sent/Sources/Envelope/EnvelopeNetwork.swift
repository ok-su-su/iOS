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
import OSLog
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
    case searchLatestOfThreeEnvelope(friendID: Int64)
    case searchEnvelope(friendID: Int64, page: Int)
    case deleteFriend(friendID: Int64)
    case deleteEnvelope(envelopeID: Int64)
    case searchEnvelopeByID(Int64)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchEnvelope,
           .searchLatestOfThreeEnvelope:
        "envelopes"
      case .deleteFriend:
        "friends"
      case let .searchEnvelopeByID(id):
        "envelopes/\(id)"
      case let .deleteEnvelope(envelopeID: id):
        "envelopes/\(id)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .deleteEnvelope,
           .deleteFriend:
        return .delete
      default:
        return .get
      }
    }

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
      case let .deleteFriend(friendID: friendID):
        return .requestParameters(parameters: ["ids": friendID], encoding: URLEncoding.queryString)

      case .searchEnvelopeByID:
        return .requestPlain

      case .deleteEnvelope:
        return .requestPlain
      }
    }
  }

  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelope(friendID: Int64, page: Int) async throws -> [EnvelopeContent] {
    os_log("요청한 Page \(page)")
    let data: SearchLatestOfThreeEnvelopeResponseDTO = try await provider.request(.searchEnvelope(friendID: friendID, page: page))
    return data.data.map { $0.toEnvelopeContent() }
  }

  func getEnvelope(id: Int64) async throws -> [EnvelopeContent] {
    let data: SearchLatestOfThreeEnvelopeResponseDTO = try await provider.request(.searchLatestOfThreeEnvelope(friendID: id))
    return data.data.map { $0.toEnvelopeContent() }
  }

  func deleteFriend(id: Int64) async throws {
    try await provider.request(.deleteFriend(friendID: id))
  }

  func deleteEnvelope(id: Int64) async throws {
    try await provider.request(.deleteEnvelope(envelopeID: id))
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
      eventName: category.category,
      envelopeType: envelope.type == "SENT" ? .sent : .receive,
      price: envelope.amount
    )
  }
}
