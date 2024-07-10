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
        CreateEnvelopeBottomOfNextButtonView(store: store.scope(state: \.nextButton, action: \.scope.nextButton))
      }
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
    static let titleText = "추가로 남기실 내용이 있나요"
  }
}
