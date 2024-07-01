// 
//  CreateLedgerDate.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture
import FeatureAction
import SSBottomSelectSheet

@Reducer
struct CreateLedgerDate {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var titleText: String
    var displayType: CreateLedgerDateDisplayDateType
    var pushable = false

    @Shared var startSelectedDate: Date
    @Shared var isInitialStateOfStartDate: Bool
    @Shared var endSelectedDate: Date
    @Shared var isInitialStateOfEndDate: Bool

    @Presents var datePicker: SSDateSelectBottomSheetReducer.State?
    init () {
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
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear) :
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case .tappedStartDatePicker:
      return .none

    case .tappedEndDatePicker:
      return .none

    case .tappedDeleteEndDate:
      return .none
      
    case .tappedChangeDisplayTypeButton:
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { state, action in
    return .none
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { state, action in
    return .none
  }

  var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> = { state, action in
    return .none
  }

  var delegateAction: (_ state: inout State, _ action: Action.DelegateAction) -> Effect<Action> = { state, action in
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
      case let .scope(currentAction) :
        return scopeAction(&state, currentAction)
      case let .delegate(currentAction) :
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

enum CreateLedgerDateDisplayDateType {
  case startDate
  case startAndEndDate
}
