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
  private func makeContentView() -> some View {}

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
    }
    .onAppear {
      store.send(.onAppear(true))
    }
    .onDisappear {
      store.send(.onAppear(false))
    }
  }

  // MARK: Init

  init(store: StoreOf<SentRouter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {}
}
