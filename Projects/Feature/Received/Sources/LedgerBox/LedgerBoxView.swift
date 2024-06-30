//
//  LedgerBoxView.swift
//  SSRoot
//
//  Created by Kim dohyun on 5/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventoryType

public enum InventoryType: Int, CaseIterable {
  case Wedding = 0
  case FirstBirthdayDay = 1
  case Funeral = 2
  case Birthday = 3

  public var type: String {
    switch self {
    case .Wedding:
      return "결혼식"
    case .FirstBirthdayDay:
      return "돌잔치"
    case .Funeral:
      return "장례식"
    case .Birthday:
      return "생일 기념일"
    }
  }
}

// MARK: - LedgerBoxView

public struct LedgerBoxView: View {
  private var property: LedgerBoxProperty
  init(_ property: LedgerBoxProperty) {
    self.property = property
  }

  @ViewBuilder
  public func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      let smallBadgeColor: SmallBadgeProperty.BadgeColor = .init(rawValue: property.style) ?? .gray40
      SmallBadge(property: .init(size: .small, badgeString: property.categoryName, badgeColor: smallBadgeColor))
        .padding(.bottom, 8)

      Text(property.categoryDescription)
        .modifier(SSTypoModifier(.title_m))
        .lineLimit(1)
        .truncationMode(.tail) // ....으로 표시됨
        .foregroundColor(SSColor.gray100)
        .padding(.bottom, 20)

      Text(totalAmountText)
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundColor(SSColor.gray70)
        .padding(.bottom, 4)

      Text(totalAmountEnvelopeCountText)
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundColor(SSColor.gray50)
    }
    .padding(.all, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(SSColor.gray10)
    .cornerRadius(4)
  }

  public var body: some View {
    makeContentView()
  }

  private var totalAmountText: String {
    guard let currentAmount = CustomNumberFormatter.formattedByThreeZero(property.totalAmount, subFixString: "원") else {
      return ""
    }
    return "전체" + currentAmount
  }

  private var totalAmountEnvelopeCountText: String {
    guard let currentEnvelopesCount = CustomNumberFormatter.formattedByThreeZero(property.envelopesCount, subFixString: "") else {
      return ""
    }
    return "총 " + currentEnvelopesCount + "개"
  }
}

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
    self.id = dto.ledger.id
    self.categoryName = dto.category.category
    self.style = dto.category.style
    self.isMiscCategory = dto.category.customCategory != nil
    self.categoryDescription = dto.ledger.title
    self.totalAmount = dto.totalAmounts
    self.envelopesCount = dto.totalCounts
  }
}

