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

// MARK: - EnvelopeNetwork

struct EnvelopeNetwork: Equatable, DependencyKey {
  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelope(friendID: Int64, page: Int) async throws -> [EnvelopeContent] {
    os_log("요청한 Page \(page)")
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.searchEnvelope(friendID: friendID, page: page))
    return data.data.map { $0.toEnvelopeContent() }
  }

  func getEnvelope(friendID: Int64) async throws -> [EnvelopeContent] {
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.searchLatestOfThreeEnvelope(friendID: friendID))
    return data.data.map { $0.toEnvelopeContent() }
  }

  func getEnvelope(envelopeID: Int64) async throws -> EnvelopeContent {
    let data: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(envelopeID))

    return data.toEnvelopeContent()
  }

  func deleteFriend(id: Int64) async throws {
    try await provider.request(.deleteFriend(friendID: id))
  }

  func deleteEnvelope(id: Int64) async throws {
    try await provider.request(.deleteEnvelope(envelopeID: id))
  }

  func getEnvelopeProperty(ID: Int64) async throws -> EnvelopeProperty? {
    let data: PageResponseDtoGetFriendStatisticsResponse = try await provider.request(.getEnvelopeProperty(friendID: ID))
    guard let firstData = data.data.first else {
      return nil
    }
    return EnvelopeProperty(
      id: firstData.friend.id,
      envelopeTargetUserName: firstData.friend.name,
      totalPrice: firstData.totalAmounts,
      totalSentPrice: firstData.sentAmounts,
      totalReceivedPrice: firstData.receivedAmounts
    )
  }
}

extension EnvelopeNetwork {
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
    case getEnvelopeProperty(friendID: Int64)

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
      case let .getEnvelopeProperty(friendID: id):
        "envelopes/friend-statistics"
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
        .requestParameters(
          parameters: [
            "friendIds": friendID,
            "size": 3,
            "include": "FRIEND,RELATIONSHIP,CATEGORY",
          ],
          encoding: URLEncoding.queryString
        )

      case let .searchEnvelope(friendID: friendID, page: page):
        .requestParameters(
          parameters: [
            "friendIds": friendID,
            "size": 15,
            "include": "FRIEND,RELATIONSHIP,CATEGORY",
            "page": page,
          ],
          encoding: URLEncoding.queryString
        )
      case let .deleteFriend(friendID: friendID):
        .requestParameters(parameters: ["ids": friendID], encoding: URLEncoding.queryString)

      case .searchEnvelopeByID:
        .requestPlain

      case .deleteEnvelope:
        .requestPlain

      case let .getEnvelopeProperty(friendID):
        .requestParameters(parameters: ["friendIds": friendID], encoding: URLEncoding.queryString)
      }
    }
  }
}

extension DependencyValues {
  var envelopeNetwork: EnvelopeNetwork {
    get { self[EnvelopeNetwork.self] }
    set { self[EnvelopeNetwork.self] = newValue }
  }
}

// MARK: - SearchLatestOfThreeEnvelopeDataResponseDTO

extension SearchEnvelopeResponse {
  func toEnvelopeContent() -> EnvelopeContent {
    return .init(
      id: envelope.id,
      dateText: CustomDateFormatter.getYearAndMonthDateString(from: envelope.handedOverAt) ?? "",
      eventName: category?.category ?? "",
      envelopeType: envelope.type == "SENT" ? .sent : .receive,
      price: envelope.amount
    )
  }
}

extension EnvelopeDetailResponse {
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
