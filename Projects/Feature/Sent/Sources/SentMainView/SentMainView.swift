//
//  SentMainView.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - SentMainView

public struct SentMainView: View {
  @Bindable var store: StoreOf<SentMain>

  public init(store: StoreOf<SentMain>) {
    self.store = store
  }

  @ViewBuilder
  private func makeEnvelope() -> some View {
    if store.state.envelopes.isEmpty {
      VStack {
        Text(Constants.emptyEnvelopesText)
          .modifier(SSTypoModifier(.text_s))
        SSButton(Constants.emptyEnvelopeButtonProperty) {
          store.send(.tappedEmptyEnvelopeButton)
        }
      }
    } else {
      ScrollView {
        LazyVGrid(
          columns: [GridItem(.flexible(minimum: 128))],
          spacing: 8
        ) {
          ForEach(store.scope(state: \.envelopes, action: \.envelopes)) { store in
            EnvelopeView(store: store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
      }
    }
  }

  public var body: some View {
    VStack {
      HStack(spacing: Constants.topButtonsSpacing) {
        SSButton(Constants.latestButtonProperty) {
          store.send(.tappedFirstButton)
        }
        SSButton(Constants.notSelectedFilterButtonProperty) {
          store.send(.filterButtonTapped)
        }
      }
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .padding(.bottom, Constants.topButtonsSpacing)

      makeEnvelope()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(.horizontal, Constants.leadingAndTrailingSpacing)
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let topButtonsSpacing: CGFloat = 8
    static let emptyEnvelopesText: String = "아직 보낸 봉투가 없습니다."

    static let latestButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "최신순"
    )

    static let notSelectedFilterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )

    static let emptyEnvelopeButtonProperty: SSButtonProperty = .init(
      size: .sh40,
      status: .active,
      style: .ghost,
      color: .black,
      buttonText: emptyEnvelopesText
    )
  }
}
