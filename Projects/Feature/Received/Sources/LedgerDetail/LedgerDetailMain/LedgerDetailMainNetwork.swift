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
  private static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  var getLedgerDetailByLedgerID: @Sendable (_ ledgerID: Int64) async throws -> LedgerDetailProperty
  @Sendable private static func _getLedgerDetailByLedgerID(_ ledgerID: Int64) async throws -> LedgerDetailProperty {
    let data: LedgerDetailResponse = try await provider.request(.searchLedgerDetail(ledgerID: ledgerID))
    return .init(ledgerDetailResponse: data)
  }

  var deleteLedger: @Sendable (_ id: Int64) async throws -> Void
  @Sendable private static func _deleteLedger(id: Int64) async throws {
    try await provider.request(.deletedLedger(ID: id))
  }

  var getCategories: @Sendable () async throws -> [CategoryModel]
  @Sendable private static func _getCategories() async throws -> [CategoryModel] {
    let data: CreateEnvelopesConfigResponse = try await provider.request(.getFilterItems)
    return data.categories.sorted(by: { $0.seq < $1.seq })
  }

  var getEnvelopes: @Sendable (_ param: GetEnvelopesRequestParameter) async throws -> [EnvelopeViewForLedgerMainProperty]
  @Sendable private static func _getEnvelopes(_ param: GetEnvelopesRequestParameter) async throws -> [EnvelopeViewForLedgerMainProperty] {
    let data: PageResponseDtoSearchEnvelopeResponse = try await provider.request(.searchEnvelope(param))
    return data.data.compactMap { cur -> EnvelopeViewForLedgerMainProperty? in
      let envelope = cur.envelope
      guard let friend = cur.friend,
            let relationship = cur.relationship
      else {
        return nil
      }
      return .init(
        id: envelope.id,
        name: friend.name,
        relationship: relationship.relation,
        isVisited: envelope.hasVisited,
        gift: envelope.gift,
        amount: envelope.amount
      )
    }
  }

  var getEnvelopeByEnvelopeID: @Sendable (_ id: Int64) async throws -> EnvelopeViewForLedgerMainProperty
  @Sendable private static func _getEnvelopeByEnvelopeID(_ envelopeID: Int64) async throws -> EnvelopeViewForLedgerMainProperty {
    let data: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(envelopeID))
    return .init(
      id: data.envelope.id,
      name: data.friend.name,
      relationship: data.relationship.relation,
      isVisited: data.envelope.hasVisited,
      gift: data.envelope.gift,
      amount: data.envelope.amount
    )
  }

  var requestFilterItems: () async throws -> [FilterSelectableItemProperty]
  @Sendable private static func _requestFilterItems() async throws -> [FilterSelectableItemProperty] {
    let data: CreateEnvelopesConfigResponse = try await provider.request(.getFilterItems)
    var res: [FilterSelectableItemProperty] = data.categories.sorted(by: { $0.seq < $1.seq })
    return res
  }
}

// MARK: DependencyKey

extension LedgerDetailMainNetwork: DependencyKey {
  static var liveValue: LedgerDetailMainNetwork = .init(
    getLedgerDetailByLedgerID: _getLedgerDetailByLedgerID,
    deleteLedger: _deleteLedger,
    getCategories: _getCategories,
    getEnvelopes: _getEnvelopes,
    getEnvelopeByEnvelopeID: _getEnvelopeByEnvelopeID,
    requestFilterItems: _requestFilterItems
  )
  private enum Network: SSNetworkTargetType {
    case searchEnvelope(GetEnvelopesRequestParameter)
    case searchLedgerDetail(ledgerID: Int64)
    case deletedLedger(ID: Int64)
    case getFilterItems
    case getCategoriesAndRelationships
    case searchEnvelopeByID(Int64)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .searchEnvelope:
        "envelopes"
      case let .searchLedgerDetail(ledgerID):
        "ledgers/\(ledgerID)"
      case let .searchEnvelopeByID(id):
        "envelopes/\(id)"
      case .deletedLedger:
        "ledgers"
      case .getCategoriesAndRelationships,
           .getFilterItems:
        "envelopes/configs/create-envelopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchEnvelope:
        .get
      case .searchLedgerDetail:
        .get
      case .deletedLedger:
        .delete
      case .getCategoriesAndRelationships,
           .getFilterItems,
           .searchEnvelopeByID:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchEnvelope(param):
        .requestParameters(parameters: param.getParameter(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      case let .searchLedgerDetail(ledgerID):
        .requestParameters(parameters: ["id": ledgerID], encoding: URLEncoding.queryString)
      case let .deletedLedger(ID: ledgerID):
        .requestParameters(parameters: ["ids": ledgerID], encoding: URLEncoding.queryString)
      case .getCategoriesAndRelationships,
           .getFilterItems,
           .searchEnvelopeByID
           :
        .requestPlain
      }
    }
  }
}

// MARK: - GetEnvelopesRequestParameter

struct GetEnvelopesRequestParameter {
  var friendIds: [Int64] = []
  var ledgerId: Int64
  let types: String = "RECEIVED"
  var include: [String] = []
  var fromAmount: Int64?
  var toAmount: Int64?
  var page = 0
  var size = GetEnvelopesRequestParameter.defaultSize
  var sort: String?
}

extension GetEnvelopesRequestParameter {
  static let defaultSize = 20

  func getParameter() -> [String: Any] {
    var res: [String: Any] = [:]
    res["friendIds"] = friendIds
    res["ledgerId"] = ledgerId
    res["types"] = types

    res["include"] = include.isEmpty ? ["RELATIONSHIP", "FRIEND"] : include
    if let fromAmount {
      res["fromAmount"] = fromAmount
    }
    if let toAmount {
      res["toAmount"] = toAmount
    }
    res["size"] = size
    res["page"] = page
    res["sort"] = sort

    return res
  }
}
