//
//  MyStatistics.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSAlert

@Reducer
struct MyStatistics {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: MyStatisticsProperty = .init()
    var isLoading: Bool = true
    var isAlert: Bool = false
    init() {}
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case isAlert(Bool)
    case tappedAlertCreateEnvelopeButton
    case tappedScrollView
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateMyStatistics
    case updateMyStatisticsResponse(UserEnvelopeStatisticResponse)
  }

  enum AsyncAction: Equatable {
    case getStatistics
  }

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {
    case routeSentView
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case .tappedAlertCreateEnvelopeButton:
      return .send(.delegate(.routeSentView))
    case let .isAlert(val):
      state.isAlert = val
      return .none
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .merge(
        .send(.inner(.updateMyStatistics)),
        .publisher {
          NotificationCenter.default.publisher(for: SSNotificationName.tappedStatistics)
            .map { _ in return .inner(.updateMyStatistics) }
        }
      )
    case .tappedScrollView:
      state.isAlert = state.helper.isEmptyState
      return .none
    }
  }

  @Dependency(\.statisticsMainNetwork) var network

  func asyncAction(_: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .getStatistics:
      return .run { send in
        await send(.inner(.isLoading(true)))
        let property = try await network.getMyStatistics()
        await send(.inner(.updateMyStatisticsResponse(property)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case .updateMyStatistics:
      return .send(.async(.getStatistics))

    case let .updateMyStatisticsResponse(property):
      state.helper.updateUserEnvelopeStatistics(property)
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case let .async(currentAction):
        return asyncAction(&state, currentAction)

      case let .inner(currentAction):
        return innerAction(&state, currentAction)

      case .delegate:
        return .none
      }
    }
  }
}
