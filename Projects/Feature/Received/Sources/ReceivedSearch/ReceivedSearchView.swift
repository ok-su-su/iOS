//
//  ReceivedSearchView.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEnvelope
import SSSearch
import SwiftUI

struct ReceivedSearchView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<ReceivedSearch>

  // MARK: Init

  init(store: StoreOf<ReceivedSearch>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      SSSearchView(store: store.scope(state: \.search, action: \.scope.search))
        .padding(.horizontal, 16)
    }
  }

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.scope.path)) {
      ZStack {
        SSColor
          .gray15
          .ignoresSafeArea()

        VStack(spacing: 0) {
          HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          makeContentView()
        }
      }
      .navigationBarBackButtonHidden()
      .onAppear {
        store.send(.view(.onAppear(true)))
      }
    } destination: { store in
      switch store.case {
      case let .main(store):
        LedgerDetailMainView(store: store)

      case let .envelopeDetail(store):
        SpecificEnvelopeDetailView(store: store)

      case let .envelopeEdit(store):
        SpecificEnvelopeEditView(store: store)
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
