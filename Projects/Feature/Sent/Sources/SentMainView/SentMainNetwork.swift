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
    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchEnvelope:
        "envelopes"
      case .searchFriends:
        "envelopes/friend-statistics"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case let .searchEnvelope(searchEnvelopeURLParameter):
        return .requestParameters(
          parameters: searchEnvelopeURLParameter.makeParameter(),
          encoding: URLEncoding.queryString
        )
      case let .searchFriends(type):
        return .requestParameters(parameters: ["sort": type.sortString], encoding: URLEncoding.queryString)
      }
    }
  }

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

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
}

// MARK: - SearchEnvelopeURLParameter

struct SearchEnvelopeURLParameter {
  /// 지인 id
  var friendIds: [Int] = []
  /// 장부 id
  var ledgerId: Int?
  /// type: SENT, RECEIVED
  var types: [EnvelopeType] = []
  /// 포함할 데이터 목록
  var include: [IncludeType] = []
  /// 금액 조건 from
  var fromAmount: Int?
  /// 금액 조건 to
  var toAmount: Int?
  /// 페이지
  var page: Int = 0
  /// 불러올 봉투 갯수
  var size: Int = 15
  /// 정렬
  var sort: SortTypes?

  func makeParameter() -> [String: Any] {
    var res: [String: Any] = [:]
    if friendIds != [] {
      res["friendIds"] = friendIds
    }
    if let ledgerId {
      res["ledgerId"] = ledgerId
    }
    if types != [] {
      let val = types.map(\.rawValue)
      res["types"] = val
    }

    if include != [] {
      res["include"] = include.map(\.rawValue)
    }
    if let fromAmount {
      res["fromAmount"] = fromAmount
    }
    if let toAmount {
      res["toAmount"] = toAmount
    }

    res["page"] = page
    res["size"] = size

    if let sort {
      res["sort"] = sort
    }

    return res
  }
}

extension SearchEnvelopeURLParameter {
  enum EnvelopeType: String {
    case SENT
    case RECEIVED
  }

  enum IncludeType: String {
    case CATEGORY
    case FRIEND
    case RELATIONSHIP
    case FRIEND_RELATIONSHIP
  }

  enum SortTypes: String {
    case createdAt
    case desc
  }
}
