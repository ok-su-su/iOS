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

struct ReceivedSearchNetwork: Sendable {
  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  var searchLedgersByName: @Sendable (_ name: String) async throws -> [ReceivedSearchItem]
  @Sendable private static func _searchLedgersByName(_ name: String) async throws -> [ReceivedSearchItem] {
    let response: PageResponseDtoSearchLedgerResponse = try await provider.request(.searchLedgersByName(name))
    return response.data.map { val in
      let dateDescription: String?

      if val.ledger.startAt == val.ledger.endAt {
        let currentDateString = val.ledger.startAt
        dateDescription = CustomDateFormatter.getYearAndMonthDateString(from: currentDateString)
      } else {
        let startDateString = val.ledger.startAt
        let endDateString = val.ledger.endAt
        let end = CustomDateFormatter.getYearAndMonthDateString(from: endDateString) ?? ""
        let start = CustomDateFormatter.getYearAndMonthDateString(from: startDateString) ?? ""
        dateDescription = start + "-" + end
      }

      return .init(
        id: val.ledger.id,
        title: val.ledger.title,
        firstContentDescription: val.category.category,
        secondContentDescription: dateDescription
      )
    }
  }
}

// MARK: DependencyKey

extension ReceivedSearchNetwork: DependencyKey {
  static let liveValue: ReceivedSearchNetwork = .init(
    searchLedgersByName: _searchLedgersByName
  )

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
