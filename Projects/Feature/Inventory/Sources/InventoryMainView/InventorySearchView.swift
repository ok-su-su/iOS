//
//  InventorySearchView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem
import Sent

// MARK: - InventorySearch

@Reducer
struct InventorySearch {
  @ObservableState
  struct State {
    var headerType = HeaderViewFeature.State(.init(title: "", type: .depth2Default))
    @Shared var searchText: String

    init() {
      _searchText = .init("")
    }
  }

  enum Action: Equatable {
    case setHeaderView(HeaderViewFeature.Action)
  }

  var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .setHeaderView:
        return .none
      }
    }

    Scope(state: \.headerType, action: \.setHeaderView) {
      HeaderViewFeature()
    }
  }
}

// MARK: - InventorySearchView

struct InventorySearchView: View {
  @ViewBuilder
  private func makeContentView() -> some View {}

  @ViewBuilder
  private func makeSearch() -> some View {
    VStack(spacing: 16) {
      EmptyView()
    }
  }

  var body: some View {
    VStack {
      makeContentView()
    }
  }
}
