//
//  CreateLedgerRouterView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSFirebase
import SwiftUI

struct CreateLedgerRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateLedgerRouter>

  // MARK: Init

  init(store: StoreOf<CreateLedgerRouter>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      CreateLedgerCategoryView(store: store.scope(state: \.root, action: \.root))
        .ssAnalyticsScreen(moduleName: .Received(.createLedger(.category)))
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.header))
          .padding(.bottom, 24)
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
          makeContentView()
        } destination: { store in
          switch store.case {
          case let .category(store):
            CreateLedgerCategoryView(store: store)
              .ssAnalyticsScreen(moduleName: .Received(.createLedger(.category)))
          case let .name(store):
            CreateLedgerNameView(store: store)
              .ssAnalyticsScreen(moduleName: .Received(.createLedger(.name)))
          case let .date(store):
            CreateLedgerDateView(store: store)
              .ssAnalyticsScreen(moduleName: .Received(.createLedger(.date)))
          }
        }
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
