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

struct LedgerDetailEditNetwork: Sendable {
  /// 첫번쨰 인자인 LedgerID와 두번쨰 인자인 CreateAndUpdateLedgerRequestDTO를 통해 API을 요청합니다.
  var saveLedger: @Sendable (_ id: Int64, _ body: CreateAndUpdateLedgerRequestDTO) async throws -> CreateAndUpdateLedgerResponse

  @Sendable private static func _saveLedger(id: Int64, body: CreateAndUpdateLedgerRequestDTO) async throws -> CreateAndUpdateLedgerResponse {
    let data = try JSONEncoder.default.encode(body)
    return try await provider.request(.saveLedger(id: id, body: data))
  }
}

// MARK: DependencyKey

extension LedgerDetailEditNetwork: DependencyKey {
  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  static let liveValue: LedgerDetailEditNetwork = .init(
    saveLedger: _saveLedger
  )

  private enum Network: SSNetworkTargetType {
    case saveLedger(id: Int64, body: Data)

    /// SSNetworkTargetType
    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case let .saveLedger(id, _):
        "ledgers/\(id)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .saveLedger:
        .patch
      }
    }

    var task: Moya.Task {
      switch self {
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
