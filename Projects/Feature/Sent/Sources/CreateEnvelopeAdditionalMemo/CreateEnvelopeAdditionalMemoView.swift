//
//  CreateEnvelopeAdditonalMemoView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeAdditionalMemoView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalMemo>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 32) {
      // TODO: change Property
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray60)

      SSTextField(
        isDisplay: false,
        text: $store.memoHelper.textFieldText.sending(\.view.textFieldChange),
        property: .gift,
        isHighlight: $store.memoHelper.isHighlight.sending(\.view.isHighlightChanged)
      )

      Spacer()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
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
    static let titleText = "추가로 남기실 내용이 있나요"
  }
}
