//
//  LedgerDetailEdit.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet
import SSEditSingleSelectButton
import SSNotification

// MARK: - LedgerDetailEdit

@Reducer
struct LedgerDetailEdit: FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .depth2NonIconType))
    var ledgerProperty: LedgerDetailProperty
    @Shared var editProperty: LedgerDetailEditProperty
    var categorySection: SingleSelectButtonReducer<CategoryEditProperty>.State
    @Presents var datePicker: SSDateSelectBottomSheetReducer.State?

    var startDateText: (year: String, month: String, day: String) {
      editProperty.dateEditProperty.startDateText
    }

    var endDateText: (year: String, month: String, day: String)? {
      editProperty.dateEditProperty.endDateText
    }

    var isValid: Bool { editProperty.isValid }

    init(ledgerProperty: LedgerDetailProperty, ledgerDetailEditProperty: LedgerDetailEditProperty) {
      self.ledgerProperty = ledgerProperty
      _editProperty = .init(ledgerDetailEditProperty)
      categorySection = .init(
        singleSelectButtonHelper: _editProperty.categoryEditProperty,
        initialSelectedID: ledgerProperty.categoryID
      )
    }
  }

  @Dependency(\.ledgerDetailEditNetwork) var network
  @Dependency(\.updateLedgerDetailPublisher) var updateLedgerDetailPublisher
  @Dependency(\.dismiss) var dismiss
  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case changeNameTextField(String)
    case tappedStartDatePickerButton
    case tappedEndDatePickerButton
    case tappedDateToggleButton
    case tappedSaveButton
    case tappedDatePickerCompleteButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case let .changeNameTextField(name):
      state.editProperty.changeNameTextField(name)
      return .none
    case .tappedStartDatePickerButton:
      let restrictEndDate = state.editProperty.dateEditProperty.isShowEndDate ?
        state.editProperty.dateEditProperty.endDate : nil
      state.datePicker = .init(
        selectedDate: state.$editProperty.dateEditProperty.startDate,
        isInitialStateOfDate: state.$editProperty.dateEditProperty.isStartDateInitialState,
        restrictEndDate: restrictEndDate
      )
      return .none
    case .tappedEndDatePickerButton:
      state.datePicker = .init(
        selectedDate: state.$editProperty.dateEditProperty.endDate,
        isInitialStateOfDate: state.$editProperty.dateEditProperty.isEndDateInitialState,
        restrictStartDate: state.editProperty.dateEditProperty.startDate
      )
      return .none
    case .tappedDateToggleButton:
      state.editProperty.dateEditProperty.toggleShowEndDate()
      return .none

    case .tappedSaveButton:
      return .send(.async(.saveLedger))

    case .tappedDatePickerCompleteButton:
      return .send(.scope(.datePicker(.dismiss)))
    }
  }

  enum InnerAction: Equatable {
    case setInitialItem
  }

  enum AsyncAction: Equatable {
    case saveLedger
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case categorySection(SingleSelectButtonReducer<CategoryEditProperty>.Action)
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  enum DelegateAction: Equatable {}

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .saveLedger:
      let id = state.ledgerProperty.id
      let customCategory = state.editProperty.categoryEditProperty.isCustomItemSelected ?
        state.editProperty.categoryEditProperty.isCustomItem?.title : nil
      let startDate = state.editProperty.dateEditProperty.startDate
      let endDate = state.editProperty.dateEditProperty.isShowEndDate ?
        state.editProperty.dateEditProperty.endDate : startDate

      let body = CreateAndUpdateLedgerRequestDTO(
        title: state.editProperty.nameEditProperty.textFieldText,
        description: nil,
        categoryId: state.editProperty.categoryEditProperty.selectedItem?.id ?? 1,
        customCategory: customCategory,
        startAt: CustomDateFormatter.getFullDateString(from: startDate),
        endAt: CustomDateFormatter.getFullDateString(from: endDate)
      )
      return .run { _ in
        let response = try await network.saveLedger(id, body)
        let updatedLedgerID = response.ledger.id
        updateLedgerDetailPublisher.updateLedgerDetail()
        await dismiss()
      }
    }
  }

  func innerAction(_: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .setInitialItem:
      return .none
    }
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none
    case .categorySection:
      return .none
    case .datePicker:
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.categorySection, action: \.scope.categorySection) {
      SingleSelectButtonReducer()
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

extension Reducer where Self.State == LedgerDetailEdit.State, Self.Action == LedgerDetailEdit.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}
