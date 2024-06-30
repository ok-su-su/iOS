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
      return nil
    }

    var endDateText: String? {
      return nil
    }

    var defaultDateText: String {
      ""
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
    case tappedDateButton
    case tappedConfirmButton
    case tappedResetButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(bool):
      state.isAppear = bool
      return .none

    case let .tappedItem(filterSelectableItemProperty):
      return .none

    case .tappedConfirmButton:
      return .run { _ in
        await dismiss()
      }

    case .tappedResetButton:
      return .none

    case .tappedDateButton:
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

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .datePicker:
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
