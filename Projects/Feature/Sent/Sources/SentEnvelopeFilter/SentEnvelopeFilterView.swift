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

struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentEnvelopeFilter>

  // MARK: Content

  @ViewBuilder
  private func makeSendTap() -> some View {
    VStack(spacing: 0) {
      Text(Constants.searchTextFieldTitle)
        .modifier(SSTypoModifier(.title_xs))
      SSTextField(isDisplay: false, text: $store.textFieldText, property: .account, isHighlight: $store.isHighlight)
      ForEach(store.sentPeople) { person in
        SSButton(.init(size: .xsh28, status: .inactive, style: .lined, color: .black, buttonText: person.name)) {}
      }
    }
  }

  @ViewBuilder
  func makeContentView() -> some View {
    VStack {
      makeSendTap()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  // MARK: Init

  init(store: StoreOf<SentEnvelopeFilter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {
    static let searchTextFieldTitle: String = "보낸 사람"
  }
}
