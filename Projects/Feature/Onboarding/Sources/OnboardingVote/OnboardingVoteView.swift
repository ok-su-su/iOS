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
      Text("Hello World")
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

  private enum Metrics {}

  private enum Constants {}
}
