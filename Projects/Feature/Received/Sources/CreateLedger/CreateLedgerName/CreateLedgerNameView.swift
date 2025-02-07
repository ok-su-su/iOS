//
//  CreateLedgerNameView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

struct CreateLedgerNameView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateLedgerName>
  @FocusState var isFocus

  // MARK: Init

  init(store: StoreOf<CreateLedgerName>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 32) {
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      TextField(
        "",
        text: $store.textFieldText.sending(\.view.changedTextField),
        prompt: Text(Constants.promptText).foregroundStyle(SSColor.gray30),
        axis: .vertical
      )
      .focused($isFocus)
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

      VStack(spacing: 0) {
        makeContentView()
          .padding(.horizontal, 16)
      }
      .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    }
    .onAppear {
      isFocus = true
      store.send(.view(.onAppear(true)))
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      BottomNextButtonView(titleText: "다음", isActive: store.pushable) {
        store.sendViewAction(.tappedNextButton)
      }
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let titleText: String = "경조사명을 알려주세요"
    static let promptText: String = "경조사명을 입력해주세요"
  }
}
