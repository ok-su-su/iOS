//
//  CreateEnvelopeAdditionalIsGiftView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeAdditionalIsGiftView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalIsGift>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 32) {
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))

      SSTextField(
        isDisplay: false,
        text: $store.textFieldText.sending(\.view.changedTextField),
        property: .gift,
        isHighlight: $store.isHighlight.sending(\.view.changeIsHighlight)
      )
      .onChange(of: store.textFieldText) { _, newValue in
        store.send(.view(.changedTextField(newValue)))
      }

      Spacer()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(alignment: .leading, spacing: 0) {
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
        CreateEnvelopeBottomOfNextButtonView(store: store.scope(state: \.nextButton, action: \.scope.nextButton))
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
    static let titleText = "보낸 선물을 알려주세요"
  }
}
