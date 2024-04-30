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

struct SentMainView: View {
  @Bindable var store: StoreOf<SentMain>

  init(store: StoreOf<SentMain>) {
    self.store = store
  }

  @ViewBuilder
  private func makeEnvelope() -> some View {
    if store.state.envelopes.isEmpty {
      VStack {
        Spacer()
        Text(Constants.emptyEnvelopesText)
          .modifier(SSTypoModifier(.text_s))
          .foregroundStyle(SSColor.gray50)
        SSButton(Constants.emptyEnvelopeButtonProperty) {
          store.send(.tappedEmptyEnvelopeButton)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ForEach(store.scope(state: \.envelopes, action: \.envelopes)) { store in
          EnvelopeView(store: store)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.header))
        Spacer()
          .frame(height: 16)
        VStack {
          HStack(spacing: Constants.topButtonsSpacing) {
            SSButton(Constants.latestButtonProperty) {
              store.send(.tappedFirstButton)
            }
            ZStack {
              // TODO: Navigation 변경
              NavigationLink(state: SentRouter.Path.State.sentEnvelopeFilter(.init(sentPeople: [
                .init(name: "춘자"),
                .init(name: "복자"),
                .init(name: "흑자"),
                .init(name: "헬자"),
                .init(name: "함자"),
                .init(name: "귀자"),
                .init(name: "사귀자"),
              ]))) {
                SSButton(Constants.notSelectedFilterButtonProperty) {
                  store.send(.filterButtonTapped)
                }
                .allowsHitTesting(false)
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .padding(.bottom, Constants.topButtonsSpacing)

          makeEnvelope()
        }
      }
    }
    .navigationBarBackButtonHidden()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(.horizontal, Constants.leadingAndTrailingSpacing)
    .safeAreaInset(edge: .bottom) {
      SSTabbar(store: store.scope(state: \.tabBar, action: \.tabBar))
        .background {
          Color.white
        }
        .ignoresSafeArea()
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
    }
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let topButtonsSpacing: CGFloat = 8
    static let emptyEnvelopesText: String = "아직 보낸 봉투가 없습니다."
    static let addNewEnvelopeButtonText: String = "보낸 봉투 추가하기"

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
      buttonText: addNewEnvelopeButtonText
    )
  }
}
