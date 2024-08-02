//
//  MyStatistics.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

@Reducer
struct MyStatistics {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: MyStatisticsProperty = .init()
    var isLoading: Bool = true
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
    case isLoading(Bool)
    case updateMyStatistics
    case updateMyStatisticsResponse(UserEnvelopeStatisticResponse)
  }

  enum AsyncAction: Equatable {
    case getStatistics
  }

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.inner(.updateMyStatistics))
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
      }
    }
  }
}
