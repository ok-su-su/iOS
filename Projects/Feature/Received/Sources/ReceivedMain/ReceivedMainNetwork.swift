//
//  ReceivedMainNetwork.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - ReceivedMainNetwork

struct ReceivedMainNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func getLedgers(_ param: SearchLedgersRequestParameter) async throws -> [LedgerBoxProperty] {
    let dto: PageResponseDtoSearchLedgerResponse = try await provider.request(.searchLedgers(param))
    return dto.data.map { .init($0) }
  }

  func getLedger(id: Int64) async throws -> LedgerBoxProperty {
    let dto: LedgerDetailResponse = try await provider.request(.searchLedger(ledgerID: id))
    return .init(ledgerDetailResponse: dto)
  }
}

extension DependencyValues {
  var receivedMainNetwork: ReceivedMainNetwork {
    get { self[ReceivedMainNetwork.self] }
    set { self[ReceivedMainNetwork.self] = newValue }
  }
}

// MARK: - ReceivedMainNetwork + DependencyKey

extension ReceivedMainNetwork: DependencyKey {
  static var liveValue: ReceivedMainNetwork = .init()

  private enum Network: SSNetworkTargetType {
    case searchLedgers(SearchLedgersRequestParameter)
    case searchLedger(ledgerID: Int64)

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .searchLedger,
           .searchLedgers
           :
        "ledgers"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchLedger,
           .searchLedgers
           :
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchLedgers(param):
        .requestParameters(parameters: param.getParameter(), encoding: URLEncoding(arrayEncoding: .noBrackets))
      case let .searchLedger(ledgerID: id):
        .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
      }
    }
  }
}

// MARK: - SearchLedgersRequestParameter

struct SearchLedgersRequestParameter: Encodable, Equatable {
  /// 검색하는 장부 이름
  var title: String?
  /// 검색하는 카테고리 ID들
  var categoryIds: [Int]
  /// 시작일
  var fromStartAt: Date?
  /// 종료일
  var toStartAt: Date?
  /// 페이지
  var page: Int = 0
  /// 사이즈
  var size: Int = 15
  /// sort
  var sort: SortDialItem?
}

extension SearchLedgersRequestParameter {
  func getParameter() -> [String: Any] {
    var res: [String: Any] = .init()

    if let title {
      res["title"] = title
    }

    res["categoryIds"] = categoryIds

    if let fromStartAt {
      res["fromStartAt"] = CustomDateFormatter.getFullDateString(from: fromStartAt)
    }
    if let toStartAt {
      res["toStartAt"] = CustomDateFormatter.getFullDateString(from: toStartAt)
    }

    if let sort {
      res["sort"] = sort.sortString
    }

    res["page"] = page
    res["size"] = size

    return res
  }
}

private extension LedgerBoxProperty {
  init(ledgerDetailResponse response: LedgerDetailResponse) {
    id = response.ledger.id
    categoryName = response.category.category
    style = response.category.style
    isMiscCategory = response.category.customCategory != nil
    categoryDescription = response.ledger.description ?? ""
    totalAmount = response.totalAmounts
    envelopesCount = response.totalCounts
  }
}
