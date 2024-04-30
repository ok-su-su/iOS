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
      SentMainView(store: store.scope(state: \.sentMain, action: \.sentMain))
    } destination: { store in
      switch store.case {
      case let .sentEnvelopeFilter(store):
        SentEnvelopeFilterView(store: store)
      }
    }
  }

  var body: some View {
    makeContentView()
      .onAppear {
//        store.send(.onAppear(true))
      }
  }

  // MARK: Init

  init(store: StoreOf<SentRouter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {}
}
