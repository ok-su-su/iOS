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

// MARK: - CreateEnvelopeRelation

@Reducer
struct CreateEnvelopeRelation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isLoading = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.State

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isPushable: Bool = false

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.relationHelper.defaultRelations,
        selectedID: createEnvelopeProperty.relationHelper.selectedID,
        isCustomItem: createEnvelopeProperty.relationHelper.customRelation
      )
      resetSelected()
    }

    func resetSelected() {
      createEnvelopeProperty.relationHelper.resetSelectedItems()
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
      return .run { send in
        await send(.inner(.isLoading(true)))
        let defaultsItems = try await network.getRelationItems()
        await send(.inner(.update(defaultsItems)))
        await send(.inner(.isLoading(false)))
      }

    case .tappedNextButton:
      return .none
    }
  }

  enum InnerAction: Equatable {
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
      CreateEnvelopeRouterPublisher.shared.ended(.createEnvelopeRelation(state))
      return .none

    case let .isLoading(bool):
      state.isLoading = bool
      return .none

    case let .update(items):
      state.createEnvelopeProperty.relationHelper.updateItems(items)
      return .none
    }
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.Action)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .createEnvelopeSelectionItems(.delegate(.selected)):
      let pushable = !state.createEnvelopeProperty.relationHelper.selectedID.isEmpty
      state.isPushable = pushable
      return .none

    case .createEnvelopeSelectionItems:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.createEnvelopeRelationAndEventNetwork) var network

  var body: some Reducer<State, Action> {
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>(multipleSelectionCount: 1)
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

extension CreateEnvelopeRelation: FeatureViewAction, FeatureScopeAction, FeatureInnerAction {}
