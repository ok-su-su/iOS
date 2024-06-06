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
    VStack(spacing: 48) {
      VStack(spacing: 16) {
        Text(Constants.titleTest)
          .modifier(SSTypoModifier(.title_l))
        
        Text(Constants.titleDescriptionText)
          .modifier(SSTypoModifier(.text_l))
      }
      makeVoteView()
      
      Spacer()
      
      SSImage
        .signInTrademark
        .padding(.bottom, Metrics.bottomPadding)
    }
  }
  
  @ViewBuilder
  private func makeVoteView() -> some View {
    ForEach(store.helper.items) {item in
      SSButton(
        .init(
          size: .mh60,
          status: .inactive,
          style: .ghost,
          color: .black,
          buttonText: item.title)) {
            store.send(.view(.tappedButtonItem(item)))
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
    static let bottomPadding:CGFloat = 24
  }

  private enum Constants {
    static let titleTest: String = "친구의 결혼식"
    static let titleDescriptionText: String = "**축의금**은 **얼마가 적당하다**고\n생각하시나요"
  }
}
