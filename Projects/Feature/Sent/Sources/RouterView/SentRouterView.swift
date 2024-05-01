//
//  SentRouterView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SentRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentRouter>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      EmptyView()
    } destination: { store in
      switch store.case {
      case let .sentMain(store):
        SentMainView(store: store)
      case let .sentEnvelopeFilter(store):
        SentEnvelopeFilterView(store: store)
      case let .searchEnvelope(store):
        SearchEnvelopeView(store: store)
      }
    }
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  var body: some View {
    makeContentView()
      .onAppear {}
  }

  // MARK: Init

  init(store: StoreOf<SentRouter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {}
}
