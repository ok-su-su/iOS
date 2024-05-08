//
//  CreateEnvelopeRelation.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeRelation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.State

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isAddingNewRelation: Bool = false

    var addingCustomRelationText = ""
    var addingCustomRelationHighlight = false
    var customRelationSaved: Bool = false

    var isAvailableAddingCustomRelationSaveButton: Bool {
      return addingCustomRelationText != ""
    }

    init(createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.relationHelper.defaultRelations,
        selectedID: createEnvelopeProperty.relationHelper.selectedID,
        isCustomItem: createEnvelopeProperty.relationHelper.customRelation
      )
    }

    var defaultRelationString: [String] = [
      "친구",
      "가족",
      "친척",
      "동료",
    ]
  }

  enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>.Action)
  }

  enum DelegateAction: Equatable {
    case push
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      CreateEnvelopeSelectItems<CreateEnvelopeRelationItemProperty>(multipleSelectionCount: 1)
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .delegate:
        return .none

      case .binding:
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.delegate(.push))
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
      }
    }
  }
}
