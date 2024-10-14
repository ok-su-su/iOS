//
//  SSFilterWithDateReducer.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import FeatureAction
import Foundation
import SSBottomSelectSheet

@Reducer
public struct SSFilterWithDateReducer: Sendable {
  public init() {}

  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    var isLoading: Bool = true
    @Shared var dateProperty: SSFilterWithDateHelper
    @Presents var datePicker: SSDateSelectBottomSheetReducer.State?
    init() {
      _dateProperty = .init(.init())
    }
  }

  public enum Action: Equatable, Sendable {
    case view(ViewAction)
    case scope(ScopeAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedResetButton
    case tappedLeftDateButton
    case tappedRightDateButton
  }

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case .tappedLeftDateButton:
      // 만약 endDate를 골랐을 경우
      let restrictEndDate: Date? = state.dateProperty.isInitialStateOfEndDate ? nil : state.dateProperty.startDate
      state.datePicker = .init(
        selectedDate: state.$dateProperty.startDate,
        isInitialStateOfDate: state.$dateProperty.isInitialStateOfStartDate,
        restrictEndDate: restrictEndDate
      )
      return .none
    case .tappedRightDateButton:
      // 만약 startDate를 골랐을 경우
      let restrictStartDate: Date? = state.dateProperty.isInitialStateOfStartDate ? nil : state.dateProperty.startDate
      state.datePicker = .init(
        selectedDate: state.$dateProperty.endDate,
        isInitialStateOfDate: state.$dateProperty.isInitialStateOfEndDate,
        restrictStartDate: restrictStartDate
      )
      return .none

    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case .tappedResetButton:
      state.dateProperty.resetDate()
      return .none
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case .scope:
        return .none
      }
    }
    .ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}
