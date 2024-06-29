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

struct InventoryAccountView: View {
  @Bindable var store: StoreOf<InventoryAccount>

  @ViewBuilder
  private func makeBadgeContentView() -> some View {
    ZStack {
      SSColor.gray10
      VStack {
        HStack(spacing: 8) {
          ForEach(0 ..< store.accountType.count, id: \.self) { id in
            SmallBadge(property: .init(
              size: .small,
              badgeString: store.accountType[id].rawValue,
              badgeColor: store.accountBadgeColors[id]
            ))
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.leading, 16)

        Spacer()
          .frame(height: 12)

        HStack {
          Text(store.accountTitle)
            .modifier(SSTypoModifier(.text_xs))
            .foregroundColor(SSColor.gray90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 18)
            .padding(.leading, 16)

          Text(store.accountPriceText)
            .modifier(SSTypoModifier(.text_m))
            .foregroundColor(SSColor.gray100)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 18)
            .padding([.trailing], 16)

          SSImage
            .voteRightArrow
            .frame(maxWidth: 24, maxHeight: 24, alignment: .trailing)
            .padding(.bottom, 18)
            .padding(.trailing, 16)
        }
      }
    }
    .frame(maxHeight: 100)
    .padding(.horizontal, 16)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  var body: some View {
    VStack {
      makeBadgeContentView()
    }
  }
}
