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
    var networkHelper: OnboardingNetworkHelper = .init()
    var persistencyHelper: OnboardingVotePersistencyHelper = .init()
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

  enum InnerAction: Equatable {
    case updateVoteItems([OnboardingVoteItem])

    case saveVote
  }

  enum AsyncAction: Equatable {
    case getVoteItems
  }

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  enum CancelID {
    case getOnboardingVoteItems
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .send(.async(.getVoteItems))

      case let .view(.tappedButtonItem(item)):
        if item.title == "" {
          return .none
        }
        return .run { send in
          await send(.inner(.saveVote))
          OnboardingRouterPublisher.shared.send(.login(.init()))
        }
      case .async(.getVoteItems):
        return .run { [helper = state.networkHelper] send in
          let items = await helper.getOnboardingVoteItems()
          await send(.inner(.updateVoteItems(items)), animation: .linear(duration: 0.8))
        }
        .cancellable(id: CancelID.getOnboardingVoteItems, cancelInFlight: true)
      case let .inner(.updateVoteItems(items)):
        state.helper.items = items
        return .none
      case .inner(.saveVote):
        state.persistencyHelper.saveKeyChainIsNotInitialUser()
        return .none
      }
    }
  }
}
