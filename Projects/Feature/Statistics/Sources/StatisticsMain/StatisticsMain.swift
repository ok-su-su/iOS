//
//  StatisticsMain.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct StatisticsMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .statistics)
    var header: HeaderViewFeature.State = .init(.init(title: "통계", type: .defaultType))
    var helper: StatisticsMainProperty = .init()
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
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
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
      }
    }
  }
}