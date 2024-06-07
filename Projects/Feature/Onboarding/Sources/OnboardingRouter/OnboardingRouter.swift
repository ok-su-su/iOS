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
    var path: StackState<Path.State> = .init([.vote(.init())])
    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
    case pushPath(Path.State)
  }

  enum CancelID {
    case observePush
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
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

// MARK: OnboardingRouter.Path

extension OnboardingRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case vote(OnboardingVote)
    case login(OnboardingLogin)
    case terms(AgreeToTermsAndConditions)
  }
}

extension Reducer where State == OnboardingRouter.State, Action == OnboardingRouter.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
