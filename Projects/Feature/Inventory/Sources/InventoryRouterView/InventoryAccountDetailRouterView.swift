//
//  InventoryAccountDetailRouterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventoryAccountDetailRouterView

public struct InventoryAccountDetailRouterView: View {
  @Bindable var store: StoreOf<InventoryAccountDetailRouter>

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      EmptyView()
    } destination: { store in
      switch store.case {
      case let .showInventoryAccountDetail(store):
        InventoryAccountDetailView(store: store)
      }
    }.onAppear {
      store.send(.onAppear(true))
    }
  }
}
