//
//  SpecificEnvelopeHistoryEditView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SpecificEnvelopeHistoryEditView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryEdit>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(store.editHelper.envelopeDetailProperty.priceText)
        .modifier(SSTypoModifier(.title_xxl))
        .foregroundStyle(SSColor.gray100)
      makeSubContents()
    }
    Spacer()
  }

  @ViewBuilder
  private func makeSubContents() -> some View {
    VStack(spacing: 0) {
      makeEventEditSection()
    }
  }

  @ViewBuilder
  private func makeEventEditSection() -> some View {
    TitleAndItemsWithSingleSelectButtonView(store: store.scope(state: \.eventSection, action: \.scope.eventSection))
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {}
}
