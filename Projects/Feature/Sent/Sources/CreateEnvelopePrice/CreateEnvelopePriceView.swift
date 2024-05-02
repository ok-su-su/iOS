//
//  CreateEnvelopePriceView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopePriceView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopePrice>

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
        Button {
          store.send(.view(.dismissButtonTapped))
        } label: {
          Text("끝내")
        }
        Text("HelloWorld")
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
