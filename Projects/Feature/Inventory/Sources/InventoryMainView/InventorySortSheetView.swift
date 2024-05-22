//
//  InventorySortSheetView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventorySortSheetView

struct InventorySortSheetView: View {
  @Bindable var store: StoreOf<InventorySortSheet>

  @ViewBuilder
  private func makeContentView() -> some View {
    ForEach(0 ..< store.sortItems.count) { index in
      SSButton(
        .init(
          size: .sh48,
          status: store.sortItems[index] == store.selectedSortItem ? .active : .inactive,
          style: .ghost,
          color: .black,
          buttonText: store.sortItems[index].rawValue,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.didTapSortItem(store.sortItems[index]))
        }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        Spacer()
          .frame(height: 16)
        makeContentView()
      }
    }
  }
}
