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
      ZStack {
        SSColor
          .gray15
          .ignoresSafeArea()
        VStack {
          HeaderView(store: store.scope(state: \.headerView, action: \.headerView))
          Spacer()
            .frame(height: 16)
          SentMainView(store: store.scope(state: \.sentMain, action: \.sentMain))
        }
      }
      .safeAreaInset(edge: .bottom) {
        SSTabbar(store: store.scope(state: \.tabBar, action: \.tabBar))
          .background {
            Color.white
          }
          .ignoresSafeArea()
          .frame(height: 56)
          .toolbar(.hidden, for: .tabBar)
      }
    } destination: { store in
      switch store.state {
      case .sentEnvelopeFilter:
        if let store = store.scope(state: \.sentEnvelopeFilter, action: \.sentEnvelopeFilter) {
          SentEnvelopeFilterView(store: store)
        }
      case .sentMain:
        if let store = store.scope(state: \.sentMain, action: \.sentMain) {
          SentMainView(store: store)
        }
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
