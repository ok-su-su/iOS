//
//  LedgerDetailFilterNetwork.swift
//  Received
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - LedgerDetailFilterNetwork

struct LedgerDetailFilterNetwork {
  var getInitialDataByLedgerID: @Sendable (_ id: Int64) async throws -> [LedgerFilterItemProperty]
  @Sendable private static func _getInitialDataByLedgerID(_ ledgerID: Int64) async throws -> [LedgerFilterItemProperty] {
    let param = GetEnvelopesRequestParameter(ledgerId: ledgerID, size: 150)
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.getEnvelopeFriends(param))

    return data.data.compactMap { data -> LedgerFilterItemProperty? in
      guard let id = data.friend?.id,
            let name = data.friend?.name
      else {
        return nil
      }
      return .init(id: id, title: name)
    }
  }

  var findFriendsBy: @Sendable (_ param: FindFriendsRequestParam) async throws -> [LedgerFilterItemProperty]
  @Sendable private static func _findFriendsBy(_ param: FindFriendsRequestParam) async throws -> [LedgerFilterItemProperty] {
    // TOOD: BackEnd에 말해서 API Request Param Model 수정
    let param = GetEnvelopesRequestParameter(ledgerId: param.ledgerID)
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.getEnvelopeFriends(param))
    return data.data.compactMap { data -> LedgerFilterItemProperty? in
      guard let id = data.friend?.id,
            let name = data.friend?.name
      else {
        return nil
      }
      return .init(id: id, title: name)
    }
  }

  var getMaximumSentValue: @Sendable () async throws -> Int64
  @Sendable private static func _getMaximumSentValue() async throws -> Int64 {
    let data: SearchFilterEnvelopeResponse = try await provider.request(.getFilterConfig)
    return data.maxReceivedAmount
  }
}

extension DependencyValues {
  var ledgerDetailFilterNetwork: LedgerDetailFilterNetwork {
    get { self[LedgerDetailFilterNetwork.self] }
    set { self[LedgerDetailFilterNetwork.self] = newValue }
  }
}

// MARK: - LedgerDetailFilterNetwork + DependencyKey

extension LedgerDetailFilterNetwork: DependencyKey {
  static var liveValue: LedgerDetailFilterNetwork = .init(
    getInitialDataByLedgerID: _getInitialDataByLedgerID,
    findFriendsBy: _findFriendsBy,
    getMaximumSentValue: _getMaximumSentValue
  )
  private static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case getEnvelopeFriends(GetEnvelopesRequestParameter)
    case getFilterConfig
    case getFriends(name: String)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getEnvelopeFriends:
        "envelopes"
      case .getFilterConfig:
        "envelopes/configs/search-filter"
      case .getFriends:
        "friends"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case .getFilterConfig:
        .requestPlain
      case let .getEnvelopeFriends(param):
        .requestParameters(parameters: param.getParameter(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      case let .getFriends(name):
        .requestParameters(parameters: ["name": name], encoding: URLEncoding(arrayEncoding: .brackets))
      }
    }
  }
}

// MARK: - FindFriendsRequestParam

struct FindFriendsRequestParam {
  let name: String
  let ledgerID: Int64
}
