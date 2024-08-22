//
//  LedgerBoxProperty.swift
//  Received
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

// MARK: - LedgerBoxProperty

struct LedgerBoxProperty: Equatable, Hashable, Identifiable {
  /// 장부 아이디 입니다.
  let id: Int64
  /// 장부 카테고리 이름 입니다. ex) 결혼식 장례식
  let categoryName: String
  /// 장부 카테고리 색 입니다.
  let style: String
  /// 기타일 경우에 나타냅니다.
  let isMiscCategory: Bool?
  /// 카테고리의 부연 설명을 나타냅니다.
  let categoryDescription: String
  /// 전체 금액을 나타냅니다.
  let totalAmount: Int64
  /// 전체 받은 봉투의 갯수를 나타냅니다.
  let envelopesCount: Int64

  init(
    id: Int64,
    categoryName: String,
    style: String,
    isMiscCategory: Bool?,
    categoryDescription: String,
    totalAmount: Int64,
    envelopesCount: Int64
  ) {
    self.id = id
    self.categoryName = categoryName
    self.style = style
    self.isMiscCategory = isMiscCategory
    self.categoryDescription = categoryDescription
    self.totalAmount = totalAmount
    self.envelopesCount = envelopesCount
  }

  init(_ dto: SearchLedgerResponse) {
    id = dto.ledger.id
    categoryName = dto.category.category
    style = dto.category.style ?? "blue60"
    isMiscCategory = dto.category.customCategory != nil
    categoryDescription = dto.ledger.title
    totalAmount = dto.totalAmounts
    envelopesCount = dto.totalCounts
  }
}
