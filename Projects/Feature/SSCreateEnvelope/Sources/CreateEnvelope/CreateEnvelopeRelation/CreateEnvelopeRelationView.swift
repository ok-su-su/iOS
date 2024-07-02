//
//  CreateEnvelopeRelationView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeRelationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRelation>

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

      makeRelationButton()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeRelationButton() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        makeDefaultRelationButton()
      }
    }
  }

  @ViewBuilder
  private func makeDefaultRelationButton() -> some View {
    CreateEnvelopeSelectItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
      .modifier(SSLoadingModifier(isLoading: store.isLoading))
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    CreateEnvelopeBottomOfNextButtonView(
      store: store.scope(state: \.nextButton, action: \.scope.nextButton)
    )
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
    static let titleText: String = "나와는\n어떤 사이 인가요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
  }
}