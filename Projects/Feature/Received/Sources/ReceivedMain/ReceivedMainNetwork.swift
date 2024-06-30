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

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .searchLedgers:
        "ledgers"
      }
    }

    var method: Moya.Method {
      switch self {
      case .searchLedgers:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchLedgers(param):
        .requestParameters(parameters: param.getParameter(), encoding: URLEncoding.queryString)
      }
    }
  }
}

// MARK: - SearchLedgersRequestParameter

struct SearchLedgersRequestParameter: Encodable, Equatable {
  /// 검색하는 장부 이름
  let title: String?
  /// 시작일
  let fromStartAt: Date?
  /// 종료일
  let toStartAt: Date?
  /// 종료일
  let toEndAt: Date?
  /// 페이지
  let page: Int = 0
  /// 사이즈
  let size: Int = 15
  /// sort
  let sort: SortDialItem?
}

extension SearchLedgersRequestParameter {
  func getParameter() -> [String: Any] {
    var res: [String: Any] = .init()

    if let title {
      res["title"] = title
    }

    if let fromStartAt {
      res["fromStartAt"] = CustomDateFormatter.getFullDateString(from: fromStartAt)
    }
    if let toStartAt {
      res["toStartAt"] = CustomDateFormatter.getFullDateString(from: toStartAt)
    }
    if let toEndAt {
      res["toEndAt"] = CustomDateFormatter.getFullDateString(from: toEndAt)
    }
    if let sort {
      res["sort"] = sort.sortString
    }

    res["page"] = page
    res["size"] = size

    return res
  }
}
