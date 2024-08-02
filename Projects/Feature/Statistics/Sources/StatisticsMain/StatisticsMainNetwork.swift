//
//  StatisticsMainNetwork.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - StatisticsMainNetwork

struct StatisticsMainNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  func getMyStatistics() async throws -> UserEnvelopeStatisticResponse {
    try await provider.request(.getMyStatistics)
  }

  func getSUSUStatistics(_ val: SUSUStatisticsRequestProperty) async throws -> SUSUEnvelopeStatisticResponse {
    try await provider.request(.getSUSUStatistics(val))
  }
}

// MARK: StatisticsMainNetwork.Network

extension StatisticsMainNetwork {
  private enum Network: SSNetworkTargetType {
    case getMyStatistics
    case getSUSUStatistics(SUSUStatisticsRequestProperty)
    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getMyStatistics:
        "statistics/mine/envelope"
      case .getSUSUStatistics:
        "statistics/susu/envelope"
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
      }
    }
  }
}

// MARK: DependencyKey

extension StatisticsMainNetwork: DependencyKey {
  static var liveValue: StatisticsMainNetwork = .init()
}

extension DependencyValues {
  var statisticsMainNetwork: StatisticsMainNetwork {
    get { self[StatisticsMainNetwork.self] }
    set { self[StatisticsMainNetwork.self] = newValue }
  }
}
