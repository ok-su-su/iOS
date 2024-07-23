//
//  CreateEnvelopeAdditionalIsGiftView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

struct CreateEnvelopeAdditionalIsGiftView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalIsGift>
  @FocusState
  var focus

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 32) {
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))

      TextField(
        "",
        text: $store.textFieldText.sending(\.view.changedTextField),
        prompt: Text("무엇을 선물했나요?").foregroundStyle(SSColor.gray30),
        axis: .vertical
      )
      .onReturnKeyPressed(textFieldText: store.textFieldText) { text in
        focus = false
        store.sendViewAction(.changedTextField(text))
      }
      .submitLabel(.done)
      .keyboardType(.default)
      .focused($focus)
      .foregroundStyle(SSColor.gray100)
      .modifier(SSTypoModifier(.title_xl))

      Spacer()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(alignment: .leading, spacing: 0) {
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .nextButton(store.pushable) {
      store.sendViewAction(.tappedNextButton)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      focus = true
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
