//
//  LedgerDetailEditNetwork.swift
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

// MARK: - LedgerDetailEditNetwork

struct LedgerDetailEditNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  func getLedgerProperty() async throws {}

  func saveLedger(id: Int64, body: CreateAndUpdateLedgerRequestDTO) async throws -> CreateAndUpdateLedgerResponse {
    let data = try JSONEncoder.default.encode(body)
    return try await provider.request(.saveLedger(id: id, body: data))
  }
}

// MARK: DependencyKey

extension LedgerDetailEditNetwork: DependencyKey {
  static var liveValue: LedgerDetailEditNetwork = .init()

  private enum Network: SSNetworkTargetType {
    case getLedgerDetailProperty(id: Int64)
    case saveLedger(id: Int64, body: Data)

    /// SSNetworkTargetType
    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case let .getLedgerDetailProperty(id):
        "ledgers/\(id)"
      case let .saveLedger(id, _):
        "ledgers/\(id)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getLedgerDetailProperty:
        .get
      case .saveLedger:
        .patch
      }
    }

    var task: Moya.Task {
      switch self {
      case .getLedgerDetailProperty:
        .requestPlain
      case let .saveLedger(_, body):
        .requestData(body)
      }
    }
  }
}

extension DependencyValues {
  var ledgerDetailEditNetwork: LedgerDetailEditNetwork {
    get { self[LedgerDetailEditNetwork.self] }
    set { self[LedgerDetailEditNetwork.self] = newValue }
  }
}
