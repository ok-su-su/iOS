//
//  InventoryAccountDetailFilterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem


// MARK: - InventoryAccountDetailFilterView

struct InventoryAccountDetailFilterView: View {
  @Bindable var store: StoreOf<InventoryAccountDetailFilter>

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      Text("보낸 사람")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  private func makeProgressContentView() -> some View {
    VStack(spacing: 16) {
      Text("받은 봉투 금액")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)

      VStack(spacing: 8) {
        Text("0원 ~ 100,000원")
          .modifier(SSTypoModifier(.title_m))
          .foregroundColor(SSColor.gray100)
      }
    }
  }

  @ViewBuilder
  private func makeConfirmContentView() -> some View {
    HStack(spacing: 16) {
      ZStack {
        SSImage.commonRefresh
      }.onTapGesture {}
        .padding(10)
        .overlay {
          RoundedRectangle(cornerRadius: 100)
            .inset(by: 0.5)
            .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
        }
        .padding(.leading, 16)

      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {}
        .padding(.trailing, 16)
    }
  }

  var body: some View {
    VStack {
      HeaderView(store: store.scope(state: \.headerType, action: \.header))
      Spacer()
        .frame(height: 24)

      makeContentView()

      makeProgressContentView()

      makeConfirmContentView()
    }
    .navigationBarBackButtonHidden()
  }
}
