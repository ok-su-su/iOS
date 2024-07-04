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

  func getInitialData() async throws -> [LedgerFilterItemProperty] {
    let data: PageResponseDtoGetFriendStatisticsResponse = try await provider.request(.getInitialName)
    return data.data.map { .init(id: $0.friend.id, title: $0.friend.name) }
  }

  func findFriendsBy(name: String) async throws -> [LedgerFilterItemProperty] {
    let data: PageResponseDtoGetFriendStatisticsResponse = try await provider.request(.findByName(name))
    return data.data.map { .init(id: $0.friend.id, title: $0.friend.name) }
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
    case getInitialName
    case findByName(String)

    var additionalHeader: [String: String]? { nil }
    var path: String { "envelopes/friend-statistics" }
    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case .getInitialName:
        .requestPlain
      case let .findByName(name):
        .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
      }
    }
  }
}
