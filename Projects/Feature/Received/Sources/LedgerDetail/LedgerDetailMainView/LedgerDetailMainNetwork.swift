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

  func getEnvelopes(_ param: GetEnvelopesRequestParameter) async throws -> [EnvelopeViewForLedgerMainProperty] {
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.searchEnvelope(param))
    return data.data.compactMap{ cur ->  EnvelopeViewForLedgerMainProperty? in
      let envelope = cur.envelope
      guard let friend = cur.friend,
            let relationship = cur.relationship
      else {
        return nil
      }
      return .init(id: envelope.id, name: friend.name, relationship: relationship.relation, isVisited: envelope.hasVisited, gift: envelope.gift, amount: envelope.amount)
    }
  }
}

// MARK: DependencyKey

extension LedgerDetailMainNetwork: DependencyKey {
  static var liveValue: LedgerDetailMainNetwork = .init()
  private enum Network: SSNetworkTargetType {
    case searchEnvelope(GetEnvelopesRequestParameter)
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
      case let .searchEnvelope(param):
          .requestParameters(parameters: param.getParameter(), encoding: URLEncoding(arrayEncoding: .noBrackets))
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

  func getParameter() -> [String: Any] {
    var res: [String: Any] = [:]
    res["friendIds"] = friendIds
    res["ledgerId"] = ledgerId
    res["types"] = types
    res["include"] = ["RELATIONSHIP", "FRIEND"]
    if let fromAmount {
      res["fromAmount"] = fromAmount
    }
    if let toAmount {
      res["toAmount"] = toAmount
    }
    res ["size"] = size
    res["page"] = page
    res["sort"] = sort

    return res
  }
}

struct PageResponseDtoSearchEnvelopeResponse: Decodable {
  let data: [SearchLatestOfThreeEnvelopeDataResponseDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject
}


struct SearchLatestOfThreeEnvelopeDataResponseDTO: Decodable {
  let envelope: EnvelopeModel
  let category: CategoryWithCustomModel?
  let relationship: RelationshipModel?
  let friend: FriendModel?
  let friendRelationship: FriendRelationshipModel
}
