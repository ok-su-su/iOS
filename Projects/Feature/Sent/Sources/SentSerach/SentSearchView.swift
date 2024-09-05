//
//  SentSearchView.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEnvelope
import SSSearch
import SwiftUI
import SSFirebase

struct SentSearchView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentSearch>

  // MARK: Init

  init(store: StoreOf<SentSearch>) {
    self.store = store
  }

  // MARK: Content

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      ZStack {
        SSColor
          .gray10
          .ignoresSafeArea()

        VStack(spacing: 0) {
          HeaderView(store: store.scope(state: \.header, action: \.header))
            .padding(.bottom, 8)
          SSSearchView(store: store.scope(state: \.search, action: \.search))
            .navigationBarBackButtonHidden()
            .onAppear {
              store.send(.onAppear(true))
            }
            .padding(.horizontal, 16)
        }
      }
      .ssAnalyticsScreen(moduleName: .Sent(.search))

    } destination: { store in
      switch store.case {
      case let .specificEnvelopeHistoryDetail(store):
        SpecificEnvelopeDetailView(store: store)
      case let .specificEnvelopeHistoryList(store):
        SpecificEnvelopeHistoryListView(store: store)
      case let .specificEnvelopeHistoryEdit(store):
        SpecificEnvelopeEditView(store: store)
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
