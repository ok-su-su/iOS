//
//  StatisticsMain.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

@Reducer
struct StatisticsMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .statistics)
    var header: HeaderViewFeature.State = .init(.init(title: "통계", type: .defaultType))
    var helper: StatisticsMainProperty = .init()
    var myStatistics: MyStatistics.State = .init()
    var otherStatistics: OtherStatistics.State = .init()
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
    case tappedStepper(StepperType)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case myStatistics(MyStatistics.Action)
    case otherStatistics(OtherStatistics.Action)
  }

  enum DelegateAction: Equatable {}

  func myStatisticsDelegateAction(_: inout State, _ action: MyStatistics.DelegateAction) -> Effect<Action> {
    switch action {
    case .routeSentView:
      return .send(.scope(.tabBar(.tappedSection(.envelope))))
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }

    Scope(state: \.otherStatistics, action: \.scope.otherStatistics) {
      OtherStatistics()
    }

    Scope(state: \.myStatistics, action: \.scope.myStatistics) {
      MyStatistics()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case let .view(.tappedStepper(type)):
        state.helper.selectedStepperType = type
        return .none
      case .scope(.header):
        return .none
      case .scope(.tabBar):
        return .none

      case let .scope(.myStatistics(.delegate(currentAction))):
        return myStatisticsDelegateAction(&state, currentAction)

      case .scope(.myStatistics):
        return .none

      case .scope(.otherStatistics):
        return .none
      }
    }
  }
}
