//
//  ReceivedFilter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - ReceivedFilter

@Reducer
struct ReceivedFilter {
  @ObservableState
  struct State: Equatable {
    var isAppear = false
    @Shared var property: FilterHelperProperty
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))

    @Presents var datePicker: SSDateSelectBottomSheetReducer.State?
    init(_ property: Shared<FilterHelperProperty>) {
      _property = property
    }

    var startDateText: String? {
      if !property.isInitialStateOfStartDate {
        return CustomDateFormatter.getYearAndMonthDateString(from: property.startDate)
      }
      return nil
    }

    var endDateText: String? {
      if !property.isInitialStateOfEndDate {
        return CustomDateFormatter.getYearAndMonthDateString(from: property.endDate)
      }
      return nil
    }

    var defaultDateText: String {
      CustomDateFormatter.getYearAndMonthDateString(from: Date.now) ?? ""
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
    /// 뷰가 나타날 경우
    case onAppear(Bool)
    /// 아이템 클릭할 경우
    case tappedItem(FilterSelectableItemProperty)
    case tappedConfirmButton
    case tappedResetButton
    case tappedLeftDateButton
    case tappedRightDateButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(bool):
      state.isAppear = bool
      return .none

    case let .tappedItem(filterSelectableItemProperty):
      state.property.select(filterSelectableItemProperty.id)
      return .none

    case .tappedConfirmButton:
      return .run { _ in
        await dismiss()
      }

    case .tappedResetButton:
      state.property.resetDate()
      return .none

    case .tappedLeftDateButton:
      state.datePicker = .init(
        selectedDate: state.$property.startDate,
        isInitialStateOfDate: state.$property.isInitialStateOfStartDate
      )
      return .none
    case .tappedRightDateButton:
      // 만약 startDate를 골랐을 경우
      let restrictInitialStartDate: Date? = state.property.isInitialStateOfStartDate ? state.property.startDate : nil
      state.datePicker = .init(
        selectedDate: state.$property.endDate,
        isInitialStateOfDate: state.$property.isInitialStateOfEndDate,
        restrictInitialStartDate: restrictInitialStartDate
      )
      return .none
    }
  }

  enum InnerAction: Equatable {
    case updateSelectableItems([FilterSelectableItemProperty])
    case reset
  }

  func innerAction(_: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case .updateSelectableItems:
      return .none

    case .reset:
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getSelectableItems
  }

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getSelectableItems:
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .datePicker:
      return .none

    case .header(.tappedDismissButton):
      state.property.setInitialState()
      return .none

    case .header:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

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
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == ReceivedFilter.State, Action == ReceivedFilter.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}
