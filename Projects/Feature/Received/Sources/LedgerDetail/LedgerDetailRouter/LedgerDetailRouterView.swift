//
//  LedgerDetailRouterView.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEnvelope
import SSFirebase
import SwiftUI

struct LedgerDetailRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LedgerDetailRouter>

  // MARK: Init

  init(store: StoreOf<LedgerDetailRouter>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      LedgerDetailMainView(store: store.scope(state: \.ledgerDetailMain, action: \.ledgerDetailMain))
        .navigationBarBackButtonHidden()
        .onAppear {
          store.send(.onAppear(true))
        }
        .ssAnalyticsScreen(moduleName: .Received(.ledger(.main)))
    } destination: { store in
      switch store.case {
      case let .main(store):
        LedgerDetailMainView(store: store)
          .ssAnalyticsScreen(moduleName: .Received(.ledger(.main)))
      case let .envelopeDetail(store):
        SpecificEnvelopeDetailView(store: store)
          .ssAnalyticsScreen(moduleName: .Received(.ledger(.envelope(.detail))))
      case let .envelopeEdit(store):
        SpecificEnvelopeEditView(store: store)
          .ssAnalyticsScreen(moduleName: .Received(.ledger(.envelope(.edit))))
      case let .edit(store):
        LedgerDetailEditView(store: store)
          .ssAnalyticsScreen(moduleName: .Received(.ledger(.edit)))
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
