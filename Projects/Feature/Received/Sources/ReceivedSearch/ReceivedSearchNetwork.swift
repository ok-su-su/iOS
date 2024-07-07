//
//  ReceivedSearchNetwork.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - ReceivedSearchNetwork

struct ReceivedSearchNetwork {
  private init() {}

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func searchLedgersByName(_ name: String) async throws -> [ReceivedSearchItem] {
    let response: PageResponseDtoSearchLedgerResponse = try await provider.request(.searchLedgersByName(name))
    return response.data.map {
      .init(
        id: $0.ledger.id,
        title: $0.ledger.title,
        firstContentDescription: $0.category.category,
        secondContentDescription: $0.ledger.endAt
      )
    }
  }
}

// MARK: DependencyKey

extension ReceivedSearchNetwork: DependencyKey {
  static var liveValue: ReceivedSearchNetwork = .init()

  private enum Network: SSNetworkTargetType {
    case searchLedgersByName(String)
    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .searchLedgersByName:
        "ledgers"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchLedgersByName:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchLedgersByName(string):
        .requestParameters(parameters: ["title": string], encoding: URLEncoding.queryString)
      }
    }
  }
}

extension DependencyValues {
  var receivedSearchNetwork: ReceivedSearchNetwork {
    get { self[ReceivedSearchNetwork.self] }
    set { self[ReceivedSearchNetwork.self] = newValue }
  }
}
