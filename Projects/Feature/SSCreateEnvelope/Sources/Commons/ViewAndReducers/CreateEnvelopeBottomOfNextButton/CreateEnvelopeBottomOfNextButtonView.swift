//
//  CreateEnvelopeBottomOfNextButtonView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - CreateEnvelopeBottomOfNextButtonView

struct CreateEnvelopeBottomOfNextButtonView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeBottomOfNextButton>

  @available(*, deprecated, renamed: "nextButton(Bool:escaping:)", message: "use no tca View")
  init(store: StoreOf<CreateEnvelopeBottomOfNextButton>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {}

  var body: some View {
    SSButton(
      .init(
        size: .mh60,
        status: store.isAbleToPush ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {
      store.send(.view(.tappedNextButton))
    }
    .disabled(!store.isAbleToPush)
  }

  private enum Metrics {}

  private enum Constants {}
}

// MARK: - NextButtonView

struct NextButtonView: View {
  var isAbleToPush: Bool
  let tapAction: () -> Void

  init(isAbleToPush: Bool, tapAction: @escaping () -> Void) {
    self.isAbleToPush = isAbleToPush
    self.tapAction = tapAction
  }

  var body: some View {
    SSButton(
      .init(
        size: .mh60,
        status: isAbleToPush ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {
      tapAction()
    }
    .background(isAbleToPush ? SSColor.gray100 : SSColor.gray30)
    .disabled(isAbleToPush)
  }
}

extension View {
  func nextButton(_ isAbleToPush: Bool, tapAction: @escaping () -> Void) -> some View {
    safeAreaInset(edge: .bottom) {
      NextButtonView(isAbleToPush: isAbleToPush, tapAction: tapAction)
    }
  }
}
