//
//  OnboardingRouter.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - OnboardingRouter

@Reducer
struct OnboardingRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<OnboardingRouterPath.State> = .init([])
    var helper: OnboardingRouterProperty = .init()
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<OnboardingRouterPath>)
    case pushPath(OnboardingRouterPath.State)
  }

  enum CancelID {
    case observePush
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        if state.path.isEmpty {
          // 반드시 제거할 것
//          state.path.append(.terms(.init()))
          state.path.append(state.helper.isInitialUser() ? .vote(.init()) : .login(.init()))
        }
        return .publisher {
          OnboardingRouterPublisher
            .shared
            .publisher()
            .receive(on: RunLoop.main)
            .map { .pushPath($0) }
        }
        .cancellable(id: CancelID.observePush, cancelInFlight: true)

      case .path:
        return .none

      case let .pushPath(nextPath):
        state.path.append(nextPath)
        return .none
      }
    }
    .addFeatures0()
  }
}

// MARK: - OnboardingRouterPath

@Reducer(state: .equatable, action: .equatable)
enum OnboardingRouterPath {
  case vote(OnboardingVote)
  case login(OnboardingLogin)
  case terms(AgreeToTermsAndConditions)
  case termDetail(TermsAndConditionDetail)
  case registerName(OnboardingRegisterName)
  case additional(OnboardingAdditional)
}

extension Reducer where State == OnboardingRouter.State, Action == OnboardingRouter.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
