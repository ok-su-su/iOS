//
//  SentSearchView.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSSearch
import SwiftUI

struct SentSearchView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentSearch>

  // MARK: Init

  init(store: StoreOf<SentSearch>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      SSSearchView(store: store.scope(state: \.search, action: \.search))
    } destination: { store in
      switch store.case {
      case let .specificEnvelopeHistoryDetail(store):
        SpecificEnvelopeHistoryDetailView(store: store)
      case let .specificEnvelopeHistoryList(store):
        SpecificEnvelopeHistoryListView(store: store)
      case let .specificEnvelopeHistoryEdit(store):
        SpecificEnvelopeHistoryEditView(store: store)
      }
    }

    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
