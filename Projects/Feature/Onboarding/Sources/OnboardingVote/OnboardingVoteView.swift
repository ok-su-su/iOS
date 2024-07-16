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
  // MARK: - Animation 활용하기 위한

  @State private var isVisible = false
  @State private var offsetY: CGFloat = 0

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
        Text(item.title)
          .applySSFont(.title_xs)
          .foregroundStyle(SSColor.gray30)
          .padding(.horizontal, 24)
          .padding(.vertical, 16)
          .frame(maxWidth: .infinity, alignment: .center)
          .background(SSColor.gray10)
          .cornerRadius(4)
          .onTapGesture {
            store.send(.view(.tappedButtonItem(item)))
          }
      }
    }
  }

  var body: some View {
    // for animation
    GeometryReader { geometry in

      ZStack {
        SSColor
          .gray15
          .ignoresSafeArea()

        if isVisible {
          makeContentView()
            .offset(y: offsetY)
            .transition(.opacity.animation(.easeOut(duration: 0.5)))
            .animation(.easeIn(duration: 1.2), value: offsetY)
        }
      }
      .onAppear {
        // generated by GPT
        // Calculate the initial offset as 1/10 of the screen height
        let screenHeight = geometry.size.height
        let initialOffset = screenHeight / 10

        // Set the initial offset
        offsetY = initialOffset

        withAnimation {
          isVisible = true
        }

        // Delay the animation by 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
          offsetY = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
          withAnimation {
            store.send(.view(.onAppear(true)))
            return
          }
        }
      }
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
