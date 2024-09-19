//
//  CreateEnvelopeRouterView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FirebaseAnalytics
import SSFirebase
import SwiftUI

// MARK: - CreateEnvelopeRouterView

struct CreateEnvelopeRouterView: View {
  private var completion: (Data) -> Void
  @Environment(\.dismiss) var dismiss

  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRouter>

  init(store: StoreOf<CreateEnvelopeRouter>, completion: @escaping (Data) -> Void) {
    self.completion = completion
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeNavigationView() -> some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      CreateEnvelopePriceView(store: store.scope(state: \.createPrice, action: \.createPrice))
        .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .price))
    } destination: { nextStore in
      switch nextStore.case {
      case let .createEnvelopePrice(childStore):
        CreateEnvelopePriceView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .price))
      case let .createEnvelopeName(childStore):
        CreateEnvelopeNameView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .name))
      case let .createEnvelopeRelation(childStore):
        CreateEnvelopeRelationView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .relation))
      case let .createEnvelopeEvent(childStore):
        CreateEnvelopeCategoryView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .category))
      case let .createEnvelopeDate(childStore):
        CreateEnvelopeDateView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .date))
      case let .createEnvelopeAdditionalSection(childStore):
        CreateEnvelopeAdditionalSectionView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .additionalSection))
      case let .createEnvelopeAdditionalMemo(childStore):
        CreateEnvelopeAdditionalMemoView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .memo))
      case let .createEnvelopeAdditionalContact(childStore):
        CreateEnvelopeAdditionalContactView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .contact))
      case let .createEnvelopeAdditionalIsGift(childStore):
        CreateEnvelopeAdditionalIsGiftView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .gift))
      case let .createEnvelopeAdditionalIsVisitedEvent(childStore):
        CreateEnvelopeAdditionalIsVisitedEventView(store: childStore)
          .ssAnalyticsScreen(moduleName: store.type.convertMarktingModuleName(viewType: .isVisited))
      }
    }
    .onDisappear {
      completion(store.currentCreateEnvelopeData)
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
      .modifier(SSLoadingModifierWithOverlay(isLoading: store.isLoading))
      .onAppear {
        store.send(.onAppear(true))
      }
      .onChange(of: store.dismiss) { _, newValue in
        if newValue {
          dismiss()
        }
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}

private extension CreateType {
  func convertMarktingModuleName(viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
    switch self {
    case .received:
      .Received(.createEnvelope(viewType))
    case .sent:
      .Sent(.createEnvelope(viewType))
    }
  }
}

private func convertMarketingModuleName(_ createType: CreateType, viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
  switch createType {
  case .sent:
    .Sent(.createEnvelope(viewType))
  case .received:
    .Received(.createEnvelope(viewType))
  }
}
