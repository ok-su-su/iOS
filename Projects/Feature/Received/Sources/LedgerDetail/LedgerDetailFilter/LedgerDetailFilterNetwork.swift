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
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func getInitialData(ledgerID: Int64) async throws -> [LedgerFilterItemProperty] {
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

  func findFriendsBy(name _: String, ledgerID: Int64) async throws -> [LedgerFilterItemProperty] {
    let param = GetEnvelopesRequestParameter(ledgerId: ledgerID)
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

  func getMaximumSentValue() async throws -> Int64 {
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
  static var liveValue: LedgerDetailFilterNetwork = .init()

  enum Network: SSNetworkTargetType {
    case getEnvelopeFriends(GetEnvelopesRequestParameter)
    case getFilterConfig

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getEnvelopeFriends:
        "envelopes"
      case .getFilterConfig:
        "envelopes/configs/search-filter"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case .getFilterConfig:
        .requestPlain
      case let .getEnvelopeFriends(param):
        .requestParameters(parameters: param.getParameter(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      }
    }
  }
}

// MARK: - SearchFilterEnvelopeResponse

struct SearchFilterEnvelopeResponse: Decodable {
  let minReceivedAmount: Int64
  let maxReceivedAmount: Int64
  let minSentAmount: Int64
  let maxSentAmount: Int64
  let totalAmount: Int64

  enum CodingKeys: CodingKey {
    case minReceivedAmount
    case maxReceivedAmount
    case minSentAmount
    case maxSentAmount
    case totalAmount
  }
}
