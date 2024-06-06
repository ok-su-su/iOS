//
//  OnboardingVote.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct OnboardingVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: OnboardingVoteHelper = .init()
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
    case tappedButtonItem(OnboardingVoteItem)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .view(.tappedButtonItem(item)):

        return .run { _ in
          // TODO: Vote Logic
          OnboardingRouterPublisher.shared.send(.login(.init()))
        }
      }
    }
  }
}
