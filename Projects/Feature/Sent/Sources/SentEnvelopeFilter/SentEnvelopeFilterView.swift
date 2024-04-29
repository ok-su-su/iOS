//
//  SentEnvelopeFilterView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  public var store: StoreOf<SentEnvelopeFilter>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {}

  public var body: some View {
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

  public init(store: StoreOf<SentEnvelopeFilter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {}
}
