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

public enum InventoryType: Int, CaseIterable, Equatable {
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
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        let smallBadgeColor: SmallBadgeProperty.BadgeColor = .init(rawValue: property.style.lowercased()) ?? .gray40
        SSBadge(property: .init(size: .small, badgeString: property.categoryName, badgeColor: smallBadgeColor))
          .padding(.bottom, 8)

        Text(property.categoryDescription)
          .modifier(SSTypoModifier(.title_m))
          .lineLimit(1)
          .truncationMode(.tail) // ....으로 표시됨
          .foregroundColor(SSColor.gray100)
          .padding(.bottom, 20)

        Spacer()

        Text(totalAmountText)
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundColor(SSColor.gray70)
          .padding(.bottom, 4)

        Text(totalAmountEnvelopeCountText)
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundColor(SSColor.gray50)
      }
      Spacer()
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
    return "전체" + " " + currentAmount
  }

  private var totalAmountEnvelopeCountText: String {
    guard let currentEnvelopesCount = CustomNumberFormatter.formattedByThreeZero(property.envelopesCount, subFixString: "") else {
      return ""
    }
    return "총 " + currentEnvelopesCount + "개"
  }
}
