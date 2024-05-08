//
//  InventoryFilterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

import ComposableArchitecture

// MARK: - InventoryFilterView

struct InventoryFilterView: View {
  @Bindable var store: StoreOf<InventoryFilter>

  init(store: StoreOf<InventoryFilter>) {
    self.store = store
  }

  private func makeHeaderContentView() -> some View {
    ZStack(alignment: .top) {
      HeaderView(store: store.scope(state: \.header, action: \.header))
      Spacer()
        .frame(height: 24)
    }
  }

  private func makeFilterContentView() -> some View {
    GeometryReader { _ in
      VStack(alignment: .leading) {
        Text("경조사 카테고리")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.gray100)
          .padding(.top, 24)
          .padding(.leading, Spacing.leading)

        HStack {
          Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
              ForEach(0 ..< store.inventoryFilter.count, id: \.self) { index in
                SSButtonWithState(store.ssButtonProperties[index, default: Constants.butonProperty]) {}
              }
            }
            .padding(.leading, Spacing.leading)
          }
        }
      }
    }
  }

  var body: some View {
    makeHeaderContentView()
    makeFilterContentView()
      .onAppear {
        store.send(.reloadFilter)
      }
      .navigationBarBackButtonHidden()
  }

  private enum Constants {
    static let butonProperty: SSButtonPropertyState = .init(size: .sh48, status: .active, style: .filled, color: .orange, buttonText: "   ")
  }

  private enum Spacing {
    static let top: CGFloat = 16
    static let leading: CGFloat = 16
  }
}
