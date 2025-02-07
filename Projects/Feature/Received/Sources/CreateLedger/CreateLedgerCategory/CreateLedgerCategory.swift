//
//  CreateLedgerCategory.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSRegexManager
import SSSelectableItems
import SSToast

// MARK: - CreateLedgerCategory

@Reducer
struct CreateLedgerCategory: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    @Shared var selectableItems: [CreateLedgerCategoryItem]
    @Shared var selectedItemsID: [Int]
    @Shared var customItems: CreateLedgerCategoryItem?
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var selection: SSSelectableItemsReducer<CreateLedgerCategoryItem>.State
    var isLoading = true
    var isPushable: Bool {
      !selectedItemsID.isEmpty
    }

    init() {
      _selectableItems = .init([])
      _selectedItemsID = .init([])
      _customItems = .init(nil)
      selection = SSSelectableItemsReducer<CreateLedgerCategoryItem>.State(
        items: _selectableItems,
        selectedID: _selectedItemsID,
        isCustomItem: _customItems,
        regexPatternString: RegexPatternString.ledger.regexString
      )
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
    case tappedNextButton
  }

  enum InnerAction: Equatable, Sendable {
    case pushNextScreen
    case isLoading(Bool)
    case updateItems([CreateLedgerCategoryItem])
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .pushNextScreen:
      return .none

    case let .isLoading(isLoading):
      state.isLoading = isLoading
      return .none

    // 마지막 기타 아이템을 제거하고 커스텀 아이템으로 만듭니다.
    case let .updateItems(items):
      let customItem = items.first { $0.isMiscCategory }
      let items = items.filter { $0.isMiscCategory == false }

      state.selectableItems = items
      state.customItems = customItem
      return .none
    }
  }

  @Dependency(\.createLedgerNetwork) var network
  enum AsyncAction: Equatable, Sendable {
    case getCreateLedgerCategoryItem
  }

  func asyncAction(_: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .getCreateLedgerCategoryItem:
      return .ssRun { send in
        await send(.inner(.isLoading(true)))
        let items = try await network.getCreateLedgerCategoryItem()
        await send(.inner(.updateItems(items)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case selection(SSSelectableItemsReducer<CreateLedgerCategoryItem>.Action)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .toast:
      return .none

    case let .selection(.delegate(.invalidText(text))):
      return ToastRegexManager.isShowToastByLedgerName(text) ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.ledger.description)))) : .none

    case .selection:
      return .none
    }
  }

  enum DelegateAction: Equatable, Sendable {}

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getCreateLedgerCategoryItem))

    case .tappedNextButton:
      if let selectedCategoryID = state.selectedItemsID.first {
        CreateLedgerSharedState.setCategoryID(selectedCategoryID)
        if state.customItems?.id == selectedCategoryID,
           let customItem = state.customItems?.title {
          CreateLedgerSharedState.setCustomCategory(customItem)
        }
        CreateLedgerRouterPathPublisher.push(.name(.init()))
      }
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.selection, action: \.scope.selection) {
      SSSelectableItemsReducer<CreateLedgerCategoryItem>()
    }
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction

extension CreateLedgerCategory: FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction {}

extension Reducer where Self.State == CreateLedgerCategory.State, Self.Action == CreateLedgerCategory.Action {}
