//
//  SearchEnvelopeView.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SearchEnvelopeView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SearchEnvelope>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    HeaderView(store: store.scope(state: \.header, action: \.header))

    CustomTextFieldView(store: store.scope(state: \.customTextField, action: \.customTextField))

    Text(store.textFieldText)
  }

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
  }

  private enum Metrics {}

  private enum Constants {}
}
