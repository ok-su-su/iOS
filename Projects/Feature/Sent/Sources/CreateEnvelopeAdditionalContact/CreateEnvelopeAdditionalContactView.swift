//
//  CreateEnvelopeAdditionalContactView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeAdditionalContactView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalContact>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 32) {
      HStack(spacing: 4) {
        Spacer()
          .frame(height: 34)

        // TODO: change Property
        Text(Constants.eventNameText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.descriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
      }

      SSTextField(
        isDisplay: false,
        text: $store.contactHelper.textFieldText.sending(\.view.changedTextField),
        property: .gift,
        isHighlight: $store.contactHelper.isHighlight.sending(\.view.changeIsHighlight)
      )

      Spacer()

      CreateEnvelopeBottomOfNextButtonView(store: store.scope(state: \.nextButton, action: \.scope.nextButton))
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()

      makeContentView()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let eventNameText = "결혼식을"
    static let descriptionText = "방문했나요?"
  }
}
