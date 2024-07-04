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
    id id: Int64,
    category: String,
    title: String,
    description: String,
    totalAmounts: Int64,
    startDate: Date,
    endDate: Date
  ) {
    self.id = id
    self.category = category
    self.title = title
    self.description = description
    self.totalAmounts = totalAmounts
    self.startDate = startDate
    self.endDate = endDate
  }
}

extension LedgerDetailProperty {
  static var initial: Self {
    .init(id: -1, category: "", title: "", description: "", totalAmounts: 0, startDate: .now, endDate: .now)
  }

  init(ledgerDetailResponse dto: LedgerDetailResponse) {
    id = dto.ledger.id
    category = dto.category.category
    title = dto.ledger.title
    description = dto.ledger.description
    totalAmounts = dto.totalAmounts
    startDate = CustomDateFormatter.getDate(from: dto.ledger.startAt) ?? .now
    endDate = CustomDateFormatter.getDate(from: dto.ledger.endAt) ?? .now
  }
}
