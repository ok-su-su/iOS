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
struct CreateLedgerDate: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
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
      // 장례식일경우 displayType을 바꿉니다.
      displayType = body.categoryId == 3 ? .startAndEndDate : .startDate

      _startSelectedDate = .init(.now)
      _isInitialStateOfStartDate = .init(true)
      _endSelectedDate = .init(.now)
      _isInitialStateOfEndDate = .init(true)
    }
  }

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedChangeDisplayTypeButton
    case tappedStartDatePicker
    case tappedEndDatePicker
    case tappedNextButton
    case tappedDatePickerNextButton
  }

  enum InnerAction: Equatable, Sendable {
    case pushNextScreen
  }

  enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  enum DelegateAction: Equatable, Sendable {}

  @Dependency(\.mainQueue) var mainQueue
  enum CancelID {
    case throttleID
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.view(.tappedStartDatePicker))

    case .tappedStartDatePicker:
      state.isInitialStateOfStartDate = true
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
        restrictStartDate: state.isInitialStateOfStartDate ? nil : state.startSelectedDate
      )
      return .none

    case .tappedChangeDisplayTypeButton:
      // toggle the state
      state.displayType = state.displayType == .startAndEndDate ? .startDate : .startAndEndDate
      state.isInitialStateOfEndDate = true
      state.endSelectedDate = .now
      return .none

    case .tappedNextButton:

      return .send(.inner(.pushNextScreen))
        .throttle(id: CancelID.throttleID, for: .seconds(2), scheduler: mainQueue, latest: false)

    case .tappedDatePickerNextButton:
      switch state.displayType {
      case .startAndEndDate:
        if state.isInitialStateOfStartDate {
          let startDate = state.startSelectedDate
          let datePickerState: SSDateSelectBottomSheetReducer.State = .init(
            selectedDate: state.$endSelectedDate,
            isInitialStateOfDate: state.$isInitialStateOfEndDate,
            restrictStartDate: startDate
          )
          return .concatenate(
            .send(.scope(.datePicker(.presented(.didSelectedStartDate(startDate))))),
            .send(.scope(.datePicker(.presented(.changeDatePickerProperty(datePickerState)))))
          )
        }

        return .send(.view(.tappedNextButton))
      case .startDate:
        return .send(.view(.tappedNextButton))
      }
    }
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .datePicker(.presented(.didTapConfirmButton)):
      return .none

    case .datePicker:
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)

      case .inner(.pushNextScreen):
        CreateLedgerSharedState.setStartDate(state.startSelectedDate)
        CreateLedgerSharedState.setEndDate(state.startSelectedDate)
        if !state.isInitialStateOfEndDate {
          CreateLedgerSharedState.setEndDate(state.endSelectedDate)
        }
        CreateLedgerRouterPathPublisher.endedScreen(.date(state))
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where Self.State == CreateLedgerDate.State, Self.Action == CreateLedgerDate.Action {
  func addFeatures() -> some Reducer<State, Action> {
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
