//
//  ProfileRouter.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - ProfileRouter

@Reducer
struct ProfileRouter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false

    init() {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      }
    }
  }
}

// MARK: ProfileRouter.Path

extension ProfileRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case profileMain(MyPageMain)
  }
}
