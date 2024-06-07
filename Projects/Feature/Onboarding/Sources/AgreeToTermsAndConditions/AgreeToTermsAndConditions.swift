//
//  AgreeToTermsAndConditions.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct AgreeToTermsAndConditions {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(title: "약관 동의", type: .defaultType))
    var helper: AgreeToTermsAndConditionsHelper
    init() {
      helper = .init()
    }
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
    case tappedTermDetailButton(TermItem)
    case tappedCheckBox(TermItem)
    case checkAllTerms
    case tappedNextScreenButton
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

      case let .view(.tappedTermDetailButton(item)):
        guard let item = state.helper.$termItems[id: item.id] else {
          return .none
        }
        OnboardingRouterPublisher.shared.send(.termDetail(.init(item: item)))
        return .none
      case .scope(.header):
        return .none
      case let .view(.tappedCheckBox(item)):
        state.helper.check(item)
        return .none

      case .view(.checkAllTerms):
        state.helper.checkAllItems()
        return .none

      case .view(.tappedNextScreenButton):
        OnboardingRouterPublisher.shared.send(.registerName(.init()))
        return .none
      }
    }
  }
}
