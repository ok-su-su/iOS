//
//  CreateEnvelopeAdditionalContactView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

struct CreateEnvelopeAdditionalContactView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalContact>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    let contactName = store.friendName ?? ""
    VStack(alignment: .leading, spacing: 32) {
      HStack(spacing: 4) {
        // TODO: change Property
        Text(contactName)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.descriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
      }

      TextField(
        "",
        text: $store.contactHelper.textFieldText.sending(\.view.changedTextField),
        prompt: Text("010-0000-0000").foregroundStyle(SSColor.gray30),
        axis: .vertical
      )
      .keyboardType(.numberPad)
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
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let descriptionText = "연락처를 남겨주세요"
  }
}
