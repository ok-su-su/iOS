//
//  CreateEnvelopeAdditonalMemoView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

struct CreateEnvelopeAdditionalMemoView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalMemo>
  @FocusState var focus

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 32) {
      // TODO: change Property
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray60)

      TextField(
        "",
        text: $store.memoHelper.textFieldText.sending(\.view.textFieldChange),
        prompt: Text("추가로 남기실 내용이 있나요").foregroundStyle(SSColor.gray30),
        axis: .vertical
      )
      .onReturnKeyPressed(textFieldText: store.memoHelper.textFieldText) { text in
        focus = false
        store.sendViewAction(.textFieldChange(text))
      }
      .focused($focus)
      .submitLabel(.done)
      .keyboardType(.default)
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
      VStack {
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
    static let titleText = "추가로 남기실 내용이 있나요"
  }
}
