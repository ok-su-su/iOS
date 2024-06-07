//
//  OnboardingAdditional.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct OnboardingAdditional {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(1)))
    var presentBirthBottomSheet: Bool = false
    var helper: OnboardingAdditionalProperty = .init()
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
    case tappedGenderButton(GenderButtonProperty)
    case tappedBirthButton
    case tappedNextButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .view(.tappedGenderButton(item)):
        state.helper.selectedGenderItem = item
        return .none

      case .view(.tappedBirthButton):
        return .none

      case .scope(.header):
        return .none

      case .view(.tappedNextButton):
        return .none
      }
    }
  }
}
