//
//  CreateLedgerDate.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - CreateLedgerDate

@Reducer
struct CreateLedgerDate {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var titleText: String
    var displayType: CreateLedgerDateDisplayDateType
    var pushable: Bool {
      if displayType == .startDate {
        return !isInitialStateOfStartDate
      } else {
        return !isInitialStateOfEndDate && !isInitialStateOfStartDate
      }
    }

    @Shared var startSelectedDate: Date
    @Shared var isInitialStateOfStartDate: Bool
    @Shared var endSelectedDate: Date
    @Shared var isInitialStateOfEndDate: Bool

    @Presents var datePicker: SSDateSelectBottomSheetReducer.State?
    init() {
      let body = CreateLedgerSharedState.getBody()
      titleText = body.title ?? "경조사는"
      displayType = body.categoryId == 3 ? .startAndEndDate : .startDate

      _startSelectedDate = .init(.now)
      _isInitialStateOfStartDate = .init(true)
      _endSelectedDate = .init(.now)
      _isInitialStateOfEndDate = .init(true)
    }
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
    case tappedDeleteEndDate
    case tappedChangeDisplayTypeButton
    case tappedStartDatePicker
    case tappedEndDatePicker
    case tappedNextButton
  }

  enum InnerAction: Equatable {
    case checkIsPushable
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case .tappedStartDatePicker:
      state.datePicker = .init(
        selectedDate: state.$startSelectedDate,
        isInitialStateOfDate: state.$isInitialStateOfStartDate,
        restrictEndDate: state.isInitialStateOfEndDate ? nil : state.endSelectedDate
      )
      return .none

    case .tappedEndDatePicker:
      state.datePicker = .init(
        selectedDate: state.$endSelectedDate,
        isInitialStateOfDate: state.$isInitialStateOfEndDate,
        restrictEndDate: state.isInitialStateOfStartDate ? nil : state.startSelectedDate
      )
      return .none

    case .tappedDeleteEndDate:
      return .none

    case .tappedChangeDisplayTypeButton:
      // toggle the state
      state.displayType = state.displayType == .startAndEndDate ? .startDate : .startAndEndDate
      state.isInitialStateOfEndDate = true
      state.endSelectedDate = .now
      return .none

    case .tappedNextButton:
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { _, action in
    switch action {
    case .datePicker(.presented(.didTapConfirmButton)):
      return .none

    case .datePicker:
      return .none
    }
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { state, action in
    switch action {
    case .checkIsPushable:
      if state.displayType == .startDate && state.isInitialStateOfStartDate == false {
        state.pushable = true
        return .none
      } else if

        state.pushable = false
      return .none
    }
  }

  var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> = { _, _ in
    return .none
  }

  var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> = { _, _ in
    return .none
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .delegate(currentAction):
        return delegateAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == CreateLedgerDate.State, Self.Action == CreateLedgerDate.Action {
  func addFeatures() {
    ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}

// MARK: - CreateLedgerDateDisplayDateType

enum CreateLedgerDateDisplayDateType {
  case startDate
  case startAndEndDate
}
