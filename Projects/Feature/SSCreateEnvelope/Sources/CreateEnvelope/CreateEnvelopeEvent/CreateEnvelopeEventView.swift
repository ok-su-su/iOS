//
//  CreateEnvelopeEventView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeEventView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeEvent>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - Buttons

      makeItem()
      Spacer()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeItem() -> some View {
    CreateEnvelopeSelectItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
      .modifier(SSLoadingModifier(isLoading: store.isLoading))
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    CreateEnvelopeBottomOfNextButtonView(store: store.scope(state: \.nextButton, action: \.scope.nextButton))
  }

  @ViewBuilder
  private func makeAddCustomRelation() -> some View {}

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()

        makeNextButton()
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .navigationBarBackButtonHidden()
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let titleText: String = "어떤 경조사였나요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
  }
}
