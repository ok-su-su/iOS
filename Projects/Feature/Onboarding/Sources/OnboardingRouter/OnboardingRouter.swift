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
struct OnboardingRouter: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var path: StackState<OnboardingRouterPath.State> = .init([])
    var helper: OnboardingRouterProperty = .init()
    init() {}
  }

  enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case path(StackActionOf<OnboardingRouterPath>)
    case pushPath(OnboardingRouterPath.State)
  }

  enum CancelID: Sendable {
    case observePush
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        if state.path.isEmpty {
          state.path.append(.vote(.init()))
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

extension Reducer where State == OnboardingRouter.State, Action == OnboardingRouter.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
