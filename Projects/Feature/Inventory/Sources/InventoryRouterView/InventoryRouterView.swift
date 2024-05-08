//
//  InventoryRouterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct InventoryRouterView: View {
  @Bindable var store: StoreOf<InventoryRouter>

  init(store: StoreOf<InventoryRouter>) {
    self.store = store
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      EmptyView()
    } destination: { store in
      switch store.case {
      case let .inventoryItem(store):
        InventoryView(inventoryStore: store)
      case let .inventoryFilterItem(store):
        InventoryFilterView(store: store)
      }
    }.onAppear {
      store.send(.onAppear(true))
    }
  }

  var body: some View {
    // TODO: 추가 예정
    makeContentView()
      .onAppear {}
  }
}
