//
//  OnboardingVoteView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct OnboardingVoteView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingVote>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 32)

      VStack(alignment: .leading, spacing: 16) {
        Text(Constants.titleTest)
          .multilineTextAlignment(.leading)
          .modifier(SSTypoModifier(.title_l))
          .foregroundStyle(SSColor.gray100)

        Text(.init(Constants.titleDescriptionText))
          .multilineTextAlignment(.leading)
          .modifier(SSTypoModifier(.text_l))
          .foregroundStyle(SSColor.gray100)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Spacer()
        .frame(height: 48)

      makeVoteView()

      Spacer()

      SSImage
        .signInTrademark
        .padding(.bottom, Metrics.bottomPadding)
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeVoteView() -> some View {
    VStack(spacing: 8) {
      ForEach(store.helper.items) { item in
        SSButton(
          .init(
            size: .mh60,
            status: .inactive,
            style: .ghost,
            color: .black,
            buttonText: item.title,
            frame: .init(maxWidth: .infinity)
          )) {
            store.send(.view(.tappedButtonItem(item)))
          }
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .navigationBarBackButtonHidden()
  }

  private enum Metrics {
    static let bottomPadding: CGFloat = 24
  }

  private enum Constants {
    static let titleTest: String = "친구의 결혼식"
    static let titleDescriptionText: String = "**축의금**은 **얼마가 적당하다**고\n생각하시나요"
  }
}