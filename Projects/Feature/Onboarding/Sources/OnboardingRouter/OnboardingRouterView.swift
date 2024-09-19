//
//  OnboardingRouterView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSFirebase
import SwiftUI

struct OnboardingRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingRouter>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Color.clear
        .onAppear {
          store.send(.onAppear(true))
        }
    } destination: { store in
      switch store.case {
      case let .vote(store):
        OnboardingVoteView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.initialVote))
      case let .login(store):
        OnboardingLoginView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.login))
      case let .terms(store):
        AgreeToTermsAndConditionsView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.agreeToTerms))
      case let .termDetail(store):
        TermsAndConditionDetailView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.termDetail))
      case let .registerName(store):
        OnboardingRegisterNameView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.registerName))
      case let .additional(store):
        OnboardingAdditionalView(store: store)
          .ssAnalyticsScreen(moduleName: .Onboarding(.additional))
      }
    }
    .navigationViewStyle(.stack)
  }

  private enum Metrics {}

  private enum Constants {}
}
