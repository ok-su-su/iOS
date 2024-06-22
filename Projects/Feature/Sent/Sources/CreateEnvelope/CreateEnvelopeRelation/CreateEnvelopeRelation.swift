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

@Reducer
struct CreateEnvelopeRelation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isLoading = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.State

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.relationHelper.defaultRelations,
        selectedID: createEnvelopeProperty.relationHelper.selectedID,
        isCustomItem: createEnvelopeProperty.relationHelper.customRelation
      )
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
  }

  enum InnerAction: Equatable {
    case push
    case isLoading(Bool)
    case update([CreateEnvelopeRelationItemProperty])
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.Action)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.createEnvelopeRelationAndEventNetwork) var network

  var body: some Reducer<State, Action> {
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>(multipleSelectionCount: 1)
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
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

      case .inner(.push):
        if let selectedID = state.createEnvelopeProperty.relationHelper.selectedID.first {
          CreateFriendRequestShared.setRelation(id: selectedID)
        } else if let customRelationName = state.createEnvelopeProperty.relationHelper.customRelation?.title {
          CreateFriendRequestShared.setCustomRelation(name: customRelationName)
        }

        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeEvent(.init(state.$createEnvelopeProperty)))
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.inner(.push))
        }

      case .scope(.nextButton):
        return .none

      case .scope(.createEnvelopeSelectionItems(.delegate(.selected))):
        let pushable = !state.createEnvelopeProperty.relationHelper.selectedID.isEmpty
        return .run { send in
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }

      case .scope(.createEnvelopeSelectionItems):
        return .none

      case let .inner(.isLoading(bool)):
        state.isLoading = bool
        return .none

      case let .inner(.update(items)):
        state.createEnvelopeProperty.relationHelper.defaultRelations = items
        return .none
      }
    }
  }
}
