//
//  LedgerDetailProperty.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - LedgerDetailProperty

struct LedgerDetailProperty: Equatable {
  /// 장부 아이디
  let id: Int64
  /// 카테고리 아이디
  let categoryID: Int
  /// 장부 카테고리
  let category: String
  /// 경조사 장부 이름
  let title: String
  /// 장부 설명
  let description: String?
  /// 전체 금액
  let totalAmounts: Int64
  /// 장부 시작 날짜
  let startDate: Date
  /// 장부 종료 날짜
  let endDate: Date
  /// CustomCategory
  var customCategory: String? = nil
  /// 봉투 갯수
  let totalCounts: Int64

  var totalAmountText: String {
    CustomNumberFormatter.formattedByThreeZero(totalAmounts, subFixString: "원") ?? ""
  }

  var accountTitleText: String {
    return title
  }

  private var startDateText: String {
    return CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
  }

  private var endDateText: String {
    return CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
  }

  var dateText: String {
    if startDate == endDate {
      return startDateText
    }
    return startDateText + " ~ " + endDateText
  }

  init(
    id: Int64,
    categoryID: Int,
    category: String,
    title: String,
    description: String,
    totalAmounts: Int64,
    startDate: Date,
    endDate: Date,
    totalCounts: Int64
  ) {
    self.id = id
    self.categoryID = categoryID
    self.category = category
    self.title = title
    self.description = description
    self.totalAmounts = totalAmounts
    self.startDate = startDate
    self.endDate = endDate
    self.totalCounts = totalCounts
  }
}

extension LedgerDetailProperty {
  static var initial: Self {
    .init(id: -1, categoryID: -1, category: "", title: "", description: "", totalAmounts: 0, startDate: .now, endDate: .now, totalCounts: 0)
  }

  init(ledgerDetailResponse dto: LedgerDetailResponse) {
    id = dto.ledger.id
    categoryID = dto.category.id
    category = dto.category.category
    customCategory = dto.category.customCategory
    title = dto.ledger.title
    description = dto.ledger.description
    totalAmounts = dto.totalAmounts
    startDate = CustomDateFormatter.getDate(from: dto.ledger.startAt) ?? .now
    endDate = CustomDateFormatter.getDate(from: dto.ledger.endAt) ?? .now
    totalCounts = dto.totalCounts
  }
}
