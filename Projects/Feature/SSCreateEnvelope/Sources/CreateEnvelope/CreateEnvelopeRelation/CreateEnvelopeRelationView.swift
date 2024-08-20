//
//  CreateEnvelopeRelationView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSSelectableItems
import SSToast
import SwiftUI

public struct CreateEnvelopeRelationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRelation>
  public init(store: StoreOf<CreateEnvelopeRelation>) {
    self.store = store
  }

  @State private var keyBoardShow: Bool = false

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
  }

  @ViewBuilder
  private func makeTitleAndRelationButton() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 34) {
          Text(Constants.titleText)
            .modifier(SSTypoModifier(.title_m))
            .foregroundStyle(SSColor.gray100)
          makeDefaultRelationButton()
        }
        Spacer()
          .frame(height: Metrics.bottomSpacing)
      }
    }
    .scrollIndicators(.hidden)
    .contentShape(Rectangle())
    .whenTapDismissKeyboard()
    .scrollBounceBehavior(.basedOnSize)
  }

  @ViewBuilder
  private func makeDefaultRelationButton() -> some View {
    SSSelectableItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
      .modifier(SSLoadingModifier(isLoading: store.isLoading))
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .whenTapDismissKeyboard()

      makeContentView()
        .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .nextButton(store.isPushable, isShow: !keyBoardShow) {
      store.sendViewAction(.tappedNextButton)
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
