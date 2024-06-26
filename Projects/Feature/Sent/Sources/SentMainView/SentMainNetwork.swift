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

struct SentMainNetwork: Equatable, DependencyKey {
  static var liveValue: SentMainNetwork = .init()

  static func == (_: SentMainNetwork, _: SentMainNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case searchEnvelope(SearchEnvelopeURLParameter)
    case searchFriends(FilterDialItem)
    case searchFriendsByParameter(SearchFriendsParameter)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchEnvelope:
        "envelopes"
      case .searchFriends,
           .searchFriendsByParameter:
        "envelopes/friend-statistics"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case let .searchEnvelope(searchEnvelopeURLParameter):
        return .requestParameters(
          parameters: searchEnvelopeURLParameter.makeParameter(),
          encoding: URLEncoding(arrayEncoding: .noBrackets)
        )
      case let .searchFriends(type):
        return .requestParameters(parameters: ["sort": type.sortString], encoding: URLEncoding.queryString)
      case let .searchFriendsByParameter(parameter):
        return .requestParameters(parameters: parameter.getURLParameters(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      }
    }
  }

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func requestSearchFriends(_ parameter: SearchFriendsParameter) async throws -> [EnvelopeProperty] {
    let data: SearchFriendsResponseDTO = try await provider.request(.searchFriendsByParameter(parameter))
    os_log("친구들의 봉투를 요청합니다.")
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

  func requestSearchFriends(_ condition: FilterDialItem = .latest) async throws -> [EnvelopeProperty] {
    let data: SearchFriendsResponseDTO = try await provider.request(.searchFriends(condition))
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
  
  func requestSearchFriends(_ amount: Int) async throws -> [SentSearchItem] {
    let data: SearchFriendsResponseDTO = try await provider.request(.searchEnvelope(.init(types: [.SENT], include: [.CATEGORY, .FRIEND],fromAmount: amount, toAmount: amount)))
    return data.data.map{
      .init(
        id: $0.friend.id,
        title: $0.friend.name,
        firstContentDescription: $0.category?.category,
        secondContentDescription: CustomDateFormatter.getYearAndMonthDateString(from: $0.envelope?.handedOverAt)
    )
    }
  }
}

// MARK: - SearchFriendsParameter

struct SearchFriendsParameter {
  var friendIds: [Int] = []
  var fromTotalAmounts: Int?
  var toTotalAmounts: Int?
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
