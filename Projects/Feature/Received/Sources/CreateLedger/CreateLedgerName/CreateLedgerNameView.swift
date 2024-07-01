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
      VStack(spacing: 0) {
        makeContentView()
          .padding(.horizontal, 16)
      }
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      NextButtonView(isPushable: store.pushable) {
        store.sendViewAction(.tappedNextButton)
      }
    }
    .modifier(SSToastModifier(toastStore: store.scope(state: \.toast, action: \.scope.toast)))
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let titleText: String = "경조사명을 알려주세요"
    static let promptText: String = "경조사명을 입력해주세요"
  }
}
