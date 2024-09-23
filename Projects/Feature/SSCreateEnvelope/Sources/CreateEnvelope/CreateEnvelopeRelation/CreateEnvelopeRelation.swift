//
//  CreateEnvelopeRelation.swift
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

// MARK: - CreateEnvelopeRelation

@Reducer
public struct CreateEnvelopeRelation {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var isLoading = false
    var createEnvelopeSelectionItems: SSSelectableItemsReducer<CreateEnvelopeRelationItemProperty>.State
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isPushable: Bool = false

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.relationHelper.defaultRelations,
        selectedID: createEnvelopeProperty.relationHelper.selectedID,
        isCustomItem: createEnvelopeProperty.relationHelper.customRelation,
        multipleSelectionCount: 1,
        regexPatternString: RegexPatternString.relationship.regexString
      )
      resetSelected()
    }

    func resetSelected() {
      createEnvelopeProperty.relationHelper.resetSelectedItems()
    }
  }

  public enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedNextButton
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .run { send in
        await send(.inner(.isLoading(true)))
        let defaultsItems = try await network.getRelationItems()
        await send(.inner(.update(defaultsItems)))
        await send(.inner(.isLoading(false)))
      }

    case .tappedNextButton:
      return .send(.inner(.push))
    }
  }

  public enum InnerAction: Equatable {
    case push
    case isLoading(Bool)
    case update([CreateEnvelopeRelationItemProperty])
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .push:
      // Set ID
      if let selectedID = state.createEnvelopeProperty.relationHelper.getSelectedID() {
        CreateFriendRequestShared.setRelation(id: selectedID)
      }

      // Set CustomRelationName if Exist
      if let customRelationName = state.createEnvelopeProperty.relationHelper.getSelectedCustomItemName() {
        CreateFriendRequestShared.setCustomRelation(name: customRelationName)
      }
      // 화면전환을 Router객체로 전환
      CreateEnvelopeRouterPublisher.shared.next(from: .createEnvelopeRelation(state))
      return .none

    case let .isLoading(bool):
      state.isLoading = bool
      return .none

    case let .update(items):
      state.createEnvelopeProperty.relationHelper.updateItems(items)
      return .none
    }
  }

  public enum AsyncAction: Equatable {}

  @CasePathable
  public enum ScopeAction: Equatable {
    case createEnvelopeSelectionItems(SSSelectableItemsReducer<CreateEnvelopeRelationItemProperty>.Action)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .toast:
      return .none

    case .createEnvelopeSelectionItems(.delegate(.selected)):
      let pushable = !state.createEnvelopeProperty.relationHelper.selectedID.isEmpty
      state.isPushable = pushable
      return .none

    case let .createEnvelopeSelectionItems(.delegate(.invalidText(text))):
      return ToastRegexManager.isShowToastByCustomRelationShip(text) ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.relation.message)))) : .none

    case .createEnvelopeSelectionItems:
      return .none
    }
  }

  public enum DelegateAction: Equatable {}

  @Dependency(\.createEnvelopeRelationAndEventNetwork) var network

  public var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      SSSelectableItemsReducer<CreateEnvelopeRelationItemProperty>()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureScopeAction, FeatureInnerAction

extension CreateEnvelopeRelation {}
