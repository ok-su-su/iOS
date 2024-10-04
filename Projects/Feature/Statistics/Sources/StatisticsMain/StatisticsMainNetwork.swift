//
//  StatisticsMainNetwork.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - StatisticsMainNetwork

@DependencyClient
struct StatisticsMainNetwork: Sendable {
  var getMyStatistics: @Sendable () async throws -> UserEnvelopeStatisticResponse
  var getSUSUStatistics: @Sendable (_ val: SUSUStatisticsRequestProperty) async throws -> SUSUEnvelopeStatisticResponse
  var getRelationAndCategory: @Sendable () async throws -> ([RelationBottomSheetItem], [CategoryBottomSheetItem])
  var getMyBirth: @Sendable () async throws -> Int?
}

// MARK: StatisticsMainNetwork.Network

extension StatisticsMainNetwork {
  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  private enum Network: SSNetworkTargetType {
    case getMyStatistics
    case getSUSUStatistics(SUSUStatisticsRequestProperty)
    case getRelationAndCategory
    case getMyBirth
    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getMyStatistics:
        "statistics/mine/envelope"
      case .getSUSUStatistics:
        "statistics/susu/envelope"
      case .getRelationAndCategory:
        "envelopes/configs/create-envelopes"
      case .getMyBirth:
        "users/my-info"
      }
    }

    var method: Moya.Method {
      .get
    }

    var task: Moya.Task {
      switch self {
      case .getMyStatistics:
        .requestPlain
      case let .getSUSUStatistics(paramProperty):
        .requestParameters(parameters: paramProperty.getQueryString(), encoding: URLEncoding.queryString)
      case .getRelationAndCategory:
        .requestPlain
      case .getMyBirth:
        .requestPlain
      }
    }
  }
}

// MARK: DependencyKey

extension StatisticsMainNetwork: DependencyKey {
  static let liveValue: StatisticsMainNetwork = .init(
    getMyStatistics: {
      return try await provider.request(.getMyStatistics)
    },
    getSUSUStatistics: { val in
      try await provider.request(.getSUSUStatistics(val))
    },
    getRelationAndCategory: {
      let data: CreateEnvelopesConfigResponse = try await provider.request(.getRelationAndCategory)
      return (
        data.relationships.sorted { $0.id < $1.id }.map { .init(description: $0.relation, id: $0.id) },
        data.categories.sorted { $0.seq < $1.seq }.map { .init(description: $0.name, id: $0.id) }
      )
    },
    getMyBirth: {
      let dto: UserInfoResponse = try await provider.request(.getMyBirth)
      return dto.birth
    }
  )
}

extension DependencyValues {
  var statisticsMainNetwork: StatisticsMainNetwork {
    get { self[StatisticsMainNetwork.self] }
    set { self[StatisticsMainNetwork.self] = newValue }
  }
}

extension SUSUEnvelopeStatisticResponse {
  var averageSentLabel: String {
    CustomNumberFormatter.toDecimal(averageSent) ?? "50,000" + "원"
  }
}
