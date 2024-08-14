//
//  CreateEnvelopeRelationView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

struct CreateEnvelopeRelationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRelation>

  @State var keyBoardShow: Bool = false

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 24)

      // MARK: - Buttons

      makeTitleAndRelationButton()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
    .padding(.bottom, Metrics.bottomSpacing)
  }

  @ViewBuilder
  private func makeTitleAndRelationButton() -> some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: 34) {
        Text(Constants.titleText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
        makeDefaultRelationButton()
      }
    }
  }

  @ViewBuilder
  private func makeDefaultRelationButton() -> some View {
    CreateEnvelopeSelectItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
      .modifier(SSLoadingModifier(isLoading: store.isLoading))
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      makeContentView()
        .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    }
    .navigationBarBackButtonHidden()
    .nextButton(store.isPushable, isShow: !keyBoardShow) {
      store.sendViewAction(.tappedNextButton)
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .onReceive(KeyBoardReadablePublisher.shared.keyboardPublisher) { newIsKeyboardVisible in
      keyBoardShow = newIsKeyboardVisible
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 32
  }

  private enum Constants {
    static let titleText: String = "나와는\n어떤 사이 인가요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
  }
}
