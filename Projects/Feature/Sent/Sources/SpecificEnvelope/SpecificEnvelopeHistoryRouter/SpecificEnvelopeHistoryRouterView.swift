//
//  SpecificEnvelopeHistoryRouterView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEnvelope
import SwiftUI

struct SpecificEnvelopeHistoryRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryRouter>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    SpecificEnvelopeHistoryListView(
      store: store.scope(state: \.envelopeHistory, action: \.envelopeHistory)
    )
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      makeContentView()
    } destination: { store in
      switch store.case {
      case let .specificEnvelopeHistoryEdit(store):
        SpecificEnvelopeEditView(store: store)
          .ssAnalyticsScreen(moduleName: .Sent(.envelope(.edit)))

      case let .specificEnvelopeHistoryDetail(store):
        SpecificEnvelopeDetailView(store: store)
          .ssAnalyticsScreen(moduleName: .Sent(.envelope(.detail)))

      case let .specificEnvelopeHistoryList(store):
        SpecificEnvelopeHistoryListView(store: store)
          .ssAnalyticsScreen(moduleName: .Sent(.specific))
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
