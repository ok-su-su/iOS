//
//  InventoryAccountView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - EnvelopeViewForLedgerMain

struct EnvelopeViewForLedgerMain: View {
  var property: EnvelopeViewForLedgerMainProperty
  @ViewBuilder
  private func makeBadgeContentView() -> some View {
    VStack(spacing: 12) {
      HStack(spacing: 8) {
        // 관계
        SmallBadge(property: .init(size: .small, badgeString: property.name, badgeColor: .orange60))
        // 방문 여부
        SmallBadge(property: .init(size: .small, badgeString: property.isVisitedString, badgeColor: .blue60))
        // 선물
        if let gift = property.gift {
          let giftText = "선물"
          SmallBadge(property: .init(size: .small, badgeString: giftText, badgeColor: .blue60))
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Text(property.name)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.gray90)

        Spacer()

        HStack(spacing: 8) {
          Text(CustomNumberFormatter.formattedByThreeZero(property.amount, subFixString: "원") ?? "")
            .modifier(SSTypoModifier(.title_m))
            .foregroundColor(SSColor.gray100)
            .frame(maxWidth: .infinity, alignment: .trailing)

          SSImage
            .voteRightArrow
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 24, maxHeight: 24, alignment: .trailing)
        }
      }
    }
    .padding(.all, 16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  var body: some View {
    makeBadgeContentView()
  }
}

// MARK: - EnvelopeViewForLedgerMainProperty

struct EnvelopeViewForLedgerMainProperty: Equatable, Hashable, Identifiable {
  /// 봉투 아이디 입니다.
  var id: Int64
  /// 봉투를 보낸사람 입름 입니다.
  var name: String
  /// 관계
  var relationship: String
  /// 방문 여부 입니다.
  var isVisited: Bool
  /// 선물 여부 입니다.
  var gift: String?
  /// 봉투 가격 입니다.
  var amount: Int64

  var isVisitedString: String {
    return isVisited ? "방문" : "미방문"
  }
}
