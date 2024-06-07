//
//  OnboardingLogin.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct OnboardingLogin {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: OnboardingLoginHelper = .init()

    init() {}
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {
    case showPieChart
    case showPercentageAndPriceText
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .merge(
          .send(.inner(.showPieChart)),
          .send(.inner(.showPercentageAndPriceText), animation: .linear(duration: 1.2))
        )

      case .inner(.showPieChart):
        state.helper.setSectorShapeProperty()
        return .none

      case .inner(.showPercentageAndPriceText):
        state.helper.setTextProperty()
        return .none
      }
    }
  }
}
