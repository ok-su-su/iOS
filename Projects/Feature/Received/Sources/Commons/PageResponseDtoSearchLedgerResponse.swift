//
//  PageResponseDtoSearchLedgerResponse.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchLedgerResponse

struct PageResponseDtoSearchLedgerResponse: Codable {
  let data: [SearchLedgerResponse]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject

  enum CodingKeys: CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchLedgerResponse

struct SearchLedgerResponse: Codable {
  let ledger: LedgerModel
  let category: CategoryWithCustomModel
  /// 총 금액
  let totalAmounts: Int64
  /// 총 봉투 갯수
  let totalCounts: Int64
  enum CodingKeys: CodingKey {
    case ledger
    case category
    case totalAmounts
    case totalCounts
  }
}

// MARK: - CategoryWithCustomModel

struct CategoryWithCustomModel: Codable {
  /// 카테고리 아이디
  let id: Int
  /// 카테고리 순서
  let seq: Int
  /// 카테고리 이름
  let category: String
  /// 커스텀 카테고리 이름
  let customCategory: String?
  /// 카테고리 스타일
  let style: String

  enum CodingKeys: CodingKey {
    case id
    case seq
    case category
    case customCategory
    case style
  }
}

// MARK: - LedgerModel

struct LedgerModel: Codable {
  /// Ledger ID
  let id: Int64
  /// 장부 이름
  let title: String
  /// 장부 상세 설명
  let description: String?
  /// 장부 시작일
  let startAt: String
  /// 장부 종료일
  let endAt: String

  enum CodingKeys: CodingKey {
    case id
    case title
    case description
    case startAt
    case endAt
  }
}

// MARK: - SortObject

struct SortObject: Equatable, Codable {
  let empty, unsorted, sorted: Bool?
}
