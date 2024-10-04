//
//  SentMainNetwork.swift
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
  var sentMainNetwork: SentMainNetwork {
    get { self[SentMainNetwork.self] }
    set { self[SentMainNetwork.self] = newValue }
  }
}

// MARK: - SentMainNetwork

struct SentMainNetwork: DependencyKey {
  var requestSearchFriends: @Sendable (_ parameter: SearchFriendsParameter) async throws -> [EnvelopeProperty]
  @Sendable private static func _requestSearchFriends(_ parameter: SearchFriendsParameter) async throws -> [EnvelopeProperty] {
    let data: PageResponseDtoGetFriendStatisticsResponse = try await provider.request(.searchFriendsByParameter(parameter))
    return data.data.map { dto -> EnvelopeProperty in
      return EnvelopeProperty(
        id: dto.friend.id,
        envelopeTargetUserName: dto.friend.name,
        totalPrice: dto.totalAmounts,
        totalSentPrice: dto.sentAmounts,
        totalReceivedPrice: dto.receivedAmounts
      )
    }
  }
}

extension SentMainNetwork {
  static let liveValue: SentMainNetwork = .init(
    requestSearchFriends: _requestSearchFriends
  )

  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case searchFriendsByParameter(SearchFriendsParameter)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case
        .searchFriendsByParameter:
        "envelopes/friend-statistics"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case let .searchFriendsByParameter(parameter):
        return .requestParameters(parameters: parameter.getURLParameters(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      }
    }
  }
}

// MARK: - SearchFriendsParameter

struct SearchFriendsParameter {
  var friendIds: [Int64] = []
  var fromTotalAmounts: Int64?
  var toTotalAmounts: Int64?
  var page: Int = 0
  var size: Int = 30
  var sort: FilterDialItem = .latest

  func getURLParameters() -> [String: Any] {
    var res: [String: Any] = [
      "friendIds": friendIds,
      "page": page,
      "size": size,
      "sort": sort.sortString,
    ]
    if let fromTotalAmounts {
      res["fromTotalAmounts"] = fromTotalAmounts
    }
    if let toTotalAmounts {
      res["toTotalAmounts"] = toTotalAmounts
    }
    return res
  }
}
