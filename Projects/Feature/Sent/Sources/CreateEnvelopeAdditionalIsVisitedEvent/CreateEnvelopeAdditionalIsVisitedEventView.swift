//
//  CreateEnvelopeAdditionalIsVisitedEventView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeAdditionalIsVisitedEventView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalIsVisitedEvent>

  // MARK: Content

  @ViewBuilder
  private func makeDefaultItems() -> some View {
    CreateEnvelopeSelectItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    CreateEnvelopeBottomOfNextButtonView(store: store.scope(state: \.nextButton, action: \.scope.nextButton))
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      HStack(spacing: 4) {
        // TODO: change Property
        Text(Constants.eventNameText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.descriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
      }

      Spacer()
        .frame(height: 34)

      makeDefaultItems()

      Spacer()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
        makeNextButton()
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

  private enum Constants {
    static let eventNameText = "결혼식을"
    static let descriptionText = "방문했나요?"
  }
}
