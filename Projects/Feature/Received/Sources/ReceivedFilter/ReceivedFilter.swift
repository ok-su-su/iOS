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
import SSFilter

// MARK: - ReceivedFilter

@Reducer
struct ReceivedFilter: Sendable {
  @ObservableState
  struct State: Equatable {
    var isAppear = false
    var isLoading: Bool = true
    @Shared var property: FilterHelperProperty
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))

    var filterState = SSFilterReducer<FilterSelectableItemProperty>.State(type: .withDate, isSearchSection: false)

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

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    /// 뷰가 나타날 경우
    case onAppear(Bool)
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(bool):
      state.isAppear = bool
      return .send(.async(.getSelectableItems))
    }
  }

  enum InnerAction: Equatable, Sendable {
    case isLoading(Bool)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  @Dependency(\.receivedFilterNetwork) var network
  enum AsyncAction: Equatable, Sendable {
    case getSelectableItems
  }

  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getSelectableItems:
      state.isLoading = true
      return .ssRun { send in
        let items = try await network.requestFilterItems().filter { $0.isCustom == false }
        await send(.scope(.filterAction(.inner(.updateItems(items)))))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
    case filterAction(SSFilterReducer<FilterSelectableItemProperty>.Action)
  }

  private func handleFilterAction(_: inout State, _ action: SSFilterReducer<FilterSelectableItemProperty>.Action) -> Effect<Action> {
    switch action {
    case let .delegate(.tappedConfirmButtonWithDateProperty(selectedItems, startDate, endDate)):
      return .run { send in
        await send(.delegate(.tappedConfirmButton))
        await dismiss()
      }

    case .delegate:
      return .none
    default:
      return .none
    }
  }

  private func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedDismissButton):
      return .none

    case .header:
      return .none

    case let .filterAction(currentAction):
      return handleFilterAction(&state, currentAction)
    }
  }

  enum DelegateAction: Equatable, Sendable {
    case tappedConfirmButton
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.filterState, action: \.scope.filterAction) {
      SSFilterReducer()
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

      case .delegate:
        return .none
      }
    }
  }
}

extension Reducer where State == ReceivedFilter.State, Action == ReceivedFilter.Action {}
