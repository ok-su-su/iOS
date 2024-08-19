//
//  CreateEnvelopeEvent.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSRegexManager
import SSSelectableItems
import SSToast

// MARK: - CreateEnvelopeEvent

@Reducer
struct CreateEnvelopeEvent {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var createEnvelopeSelectionItems: SSSelectableItemsReducer<CreateEnvelopeEventProperty>.State
    var isLoading = false
    var pushable = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.eventHelper.defaultEvent,
        selectedID: createEnvelopeProperty.eventHelper.selectedID,
        isCustomItem: createEnvelopeProperty.eventHelper.customEvent,
        regexPatternString: RegexPatternString.category.regexString
      )
      resetSelectedItems()
    }

    func resetSelectedItems() {
      createEnvelopeProperty.eventHelper.resetSelectedItems()
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
    case tappedNextButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getEventItems))
    case .tappedNextButton:
      return .send(.inner(.push))
    }
  }

  enum InnerAction: Equatable {
    case push
    case isLoading(Bool)
    case update([CreateEnvelopeEventProperty])
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case .push:
      // Set ID
      if let selectedID = state.createEnvelopeProperty.eventHelper.getSelectedItemID(),
         let selectedName = state.createEnvelopeProperty.eventHelper.getSelectedItemName() {
        CreateEnvelopeRequestShared.setEvent(id: selectedID, name: selectedName)
      }
      // Set Custom Name if exist
      if let customName = state.createEnvelopeProperty.eventHelper.getSelectedCustomItemName() {
        CreateEnvelopeRequestShared.setCustomEvent(customName)
      }

      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeDate(.init(state.$createEnvelopeProperty)))
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .update(events):
      state.createEnvelopeProperty.eventHelper.updateItems(events)
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getEventItems
  }

  func asyncAction(_: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .getEventItems:
      return .run { send in
        await send(.inner(.isLoading(true)))
        let data = try await network.getEventItems()
        await send(.inner(.update(data)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case createEnvelopeSelectionItems(SSSelectableItemsReducer<CreateEnvelopeEventProperty>.Action)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case let .createEnvelopeSelectionItems(.delegate(.selected(id))):
      let pushable = !id.isEmpty
      state.pushable = pushable
      return .none

    case let .createEnvelopeSelectionItems(.delegate(.invalidText(text))):
      return ToastRegexManager.isShowToastByCustomCategory(text) ?
        .send(.scope(.toast(.showToastMessage("경조사는 10글자까지만 입력 가능해요")))) : .none

    case .createEnvelopeSelectionItems:
      return .none

    case .toast:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.createEnvelopeRelationAndEventNetwork) var network

  var body: some Reducer<State, Action> {
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      SSSelectableItemsReducer<CreateEnvelopeEventProperty>(multipleSelectionCount: 1)
    }
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)

      case .delegate:
        return .none
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureScopeAction, FeatureAsyncAction, FeatureInnerAction

extension CreateEnvelopeEvent: FeatureViewAction, FeatureScopeAction, FeatureAsyncAction, FeatureInnerAction {}
