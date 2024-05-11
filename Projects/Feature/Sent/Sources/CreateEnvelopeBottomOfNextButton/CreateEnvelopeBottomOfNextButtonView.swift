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

struct CreateEnvelopeBottomOfNextButtonView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeBottomOfNextButton>

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
  }

  private enum Metrics {}

  private enum Constants {}
}
