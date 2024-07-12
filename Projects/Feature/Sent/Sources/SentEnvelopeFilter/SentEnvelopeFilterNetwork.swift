//
//  SentEnvelopeFilterNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - SentEnvelopeFilterNetwork

struct SentEnvelopeFilterNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func getInitialData() async throws -> [SentPerson] {
    let data: SearchFriendsResponseDTO = try await provider.request(.getInitialName)
    return data.data.map { .init(id: $0.friend.id, name: $0.friend.name) }
  }

  func findFriendsBy(name: String) async throws -> [SentPerson] {
    let data: SearchFriendsResponseDTO = try await provider.request(.findByName(name))
    return data.data.map { .init(id: $0.friend.id, name: $0.friend.name) }
  }

  func getMaximumSentValue() async throws -> Int64 {
    let data: SearchFilterEnvelopeResponse = try await provider.request(.getFilterConfig)
    return max(data.maxSentAmount, data.maxReceivedAmount)
  }
}

extension DependencyValues {
  var sentEnvelopeFilterNetwork: SentEnvelopeFilterNetwork {
    get { self[SentEnvelopeFilterNetwork.self] }
    set { self[SentEnvelopeFilterNetwork.self] = newValue }
  }
}

// MARK: - SentEnvelopeFilterNetwork + DependencyKey, Equatable

extension SentEnvelopeFilterNetwork: DependencyKey, Equatable {
  static func == (_: SentEnvelopeFilterNetwork, _: SentEnvelopeFilterNetwork) -> Bool {
    return true
  }

  static var liveValue: SentEnvelopeFilterNetwork = .init()

  enum Network: SSNetworkTargetType {
    case getInitialName
    case findByName(String)
    case findByRange(lowest: Int, highest: Int)
    case find(name: String, lowest: Int, highest: Int)
    case getFilterConfig

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getFilterConfig:
        "envelopes/configs/search-filter"
      default:
        "envelopes/friend-statistics"
      }
    }

    var method: Moya.Method { .get }
    var task: Moya.Task {
      switch self {
      case .getInitialName:
        .requestPlain
      case let .findByName(name):
        .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
      case let .findByRange(lowest, highest):
        .requestParameters(parameters: ["fromTotalAmounts": lowest, "toTotalAmounts": highest], encoding: URLEncoding.default)
      case let .find(name, lowest, highest):
        .requestParameters(
          parameters: [
            "name": name,
            "fromTotalAmounts": lowest,
            "toTotalAmounts": highest,
          ],
          encoding: URLEncoding.default
        )
      case .getFilterConfig:
        .requestPlain
      }
    }
  }
}
