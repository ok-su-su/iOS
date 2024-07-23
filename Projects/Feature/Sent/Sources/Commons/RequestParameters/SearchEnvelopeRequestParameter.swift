//
//  SearchEnvelopeRequestParameter.swift
//  Sent
//
//  Created by MaraMincho on 6/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchEnvelopeURLParameter

struct SearchEnvelopeURLParameter {
  /// 지인 id
  var friendIds: [Int] = []
  /// 장부 id
  var ledgerId: Int?
  /// type: SENT, RECEIVED
  var types: [EnvelopeType] = []
  /// 포함할 데이터 목록
  var include: [IncludeType] = []
  /// 금액 조건 from
  var fromAmount: Int64?
  /// 금액 조건 to
  var toAmount: Int64?
  /// 페이지
  var page: Int = 0
  /// 불러올 봉투 갯수
  var size: Int = 15
  /// 정렬
  var sort: SortTypes?

  func makeParameter() -> [String: Any] {
    var res: [String: Any] = [:]
    if friendIds != [] {
      res["friendIds"] = friendIds
    }
    if let ledgerId {
      res["ledgerId"] = ledgerId
    }
    if types != [] {
      let val = types.map(\.rawValue)
      res["types"] = val
    }

    if include != [] {
      res["include"] = include.map(\.rawValue)
    }
    if let fromAmount {
      res["fromAmount"] = fromAmount
    }
    if let toAmount {
      res["toAmount"] = toAmount
    }

    res["page"] = page
    res["size"] = size

    if let sort {
      res["sort"] = sort
    }

    return res
  }
}

extension SearchEnvelopeURLParameter {
  enum EnvelopeType: String {
    case SENT
    case RECEIVED
  }

  enum IncludeType: String {
    case CATEGORY
    case FRIEND
    case RELATIONSHIP
    case FRIEND_RELATIONSHIP
  }

  enum SortTypes: String {
    case createdAt
    case desc
  }
}
