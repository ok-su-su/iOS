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
    VStack(alignment: .leading, spacing: 32) {
      HStack(spacing: 4) {
        // TODO: change Property
        Text(Constants.contactNameText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.descriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
      }

      TextField(
        "",
        text: $store.contactHelper.textFieldText.sending(\.view.changedTextField),
        prompt: Text("추가로 남기실 내용이 있나요").foregroundStyle(SSColor.gray30),
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
      VStack {
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .nextButton(store.pushable) {
      store.sendViewAction(.tappedNextButton)
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let contactNameText = "김철수님의"
    static let descriptionText = "연락처를 남겨주세요"
  }
}
