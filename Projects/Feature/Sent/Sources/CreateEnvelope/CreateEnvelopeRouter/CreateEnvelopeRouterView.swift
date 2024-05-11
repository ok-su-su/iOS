//
//  CreateEnvelopeRouterView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRouter>

  // MARK: Content

  @ViewBuilder
  private func makeNavigationView() -> some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      EmptyView()
    } destination: { store in
      switch store.case {
      case let .createEnvelopePrice(store):
        CreateEnvelopePriceView(store: store)
      case let .createEnvelopeName(store):
        CreateEnvelopeNameView(store: store)
      case let .createEnvelopeRelation(store):
        CreateEnvelopeRelationView(store: store)
      case let .createEnvelopeEvent(store):
        CreateEnvelopeEventView(store: store)
      case let .createEnvelopeDate(store):
        CreateEnvelopeDateView(store: store)
      case let .createEnvelopeAdditionalSection(store):
        CreateEnvelopeAdditionalSectionView(store: store)
      case let .createEnvelopeAdditionalMemo(store):
        CreateEnvelopeAdditionalMemoView(store: store)
      case let .createEnvelopeAdditionalContact(store):
        CreateEnvelopeAdditionalContactView(store: store)
      case let .createEnvelopeAdditionalIsGift(store):
        CreateEnvelopeAdditionalIsGiftView(store: store)
      case let .createEnvelopeAdditionalIsVisitedEvent(store):
        CreateEnvelopeAdditionalIsVisitedEventView(store: store)
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.header))
        makeNavigationView()
      }
      .onAppear {
        store.send(.onAppear(true))
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
