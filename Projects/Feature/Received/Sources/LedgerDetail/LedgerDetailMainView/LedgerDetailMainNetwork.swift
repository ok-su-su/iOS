//
//  LedgerDetailMainNetwork.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

extension DependencyValues {
  var ledgerDetailMainNetwork: LedgerDetailMainNetwork {
    get { self[LedgerDetailMainNetwork.self] }
    set { self[LedgerDetailMainNetwork.self] = newValue }
  }
}

// MARK: - LedgerDetailMainNetwork

struct LedgerDetailMainNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  func getLedgerDetail(ledgerID: Int64) async throws -> LedgerDetailProperty {
    let data: LedgerDetailResponse = try await provider.request(.searchLedgerDetail(ledgerID: ledgerID))
    return .init(ledgerDetailResponse: data)
  }

  func getEnvelopes(_ parameter: GetEnvelopesRequestParameter) async throws -> [EnvelopeViewForLedgerMainProperty] {

    return []
  }
}

// MARK: DependencyKey

extension LedgerDetailMainNetwork: DependencyKey {
  static var liveValue: LedgerDetailMainNetwork = .init()
  private enum Network: SSNetworkTargetType {
    case searchEnvelope(ledgerID: Int64)
    case searchLedgerDetail(ledgerID: Int64)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchEnvelope:
        "envelopes"
      case let .searchLedgerDetail(ledgerID):
        "ledgers/\(ledgerID)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchEnvelope:
        .get
      case .searchLedgerDetail:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchEnvelope(ledgerID):
        .requestParameters(parameters: ["ledgerId": ledgerID], encoding: URLEncoding.queryString)
      case let .searchLedgerDetail(ledgerID):
        .requestParameters(parameters: ["id": ledgerID], encoding: URLEncoding.queryString)
      }
    }
  }
}

// MARK: - LedgerDetailResponse

struct LedgerDetailResponse: Decodable {
  let ledger: LedgerModel
  let category: CategoryWithCustomModel
  let totalAmounts: Int64
  let totalCounts: Int64
}

struct GetEnvelopesRequestParameter {
  var friendIds: [Int64] = []
  var ledgerId: Int64
  let types: String = "RECEIVED"
  var include: [String] = []
  var fromAmount: Int64?
  var toAmount: Int64?
  var page = 0
  let size = GetEnvelopesRequestParameter.defaultSize
  var sort: String? = nil
}


extension GetEnvelopesRequestParameter {
  static let defaultSize = 20
}
