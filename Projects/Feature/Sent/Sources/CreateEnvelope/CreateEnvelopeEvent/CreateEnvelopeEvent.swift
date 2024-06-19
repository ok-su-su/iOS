//
//  CreateEnvelopeEvent.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeEvent {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeEventProperty>.State

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.eventHelper.defaultEvent,
        selectedID: createEnvelopeProperty.eventHelper.selectedID,
        isCustomItem: createEnvelopeProperty.eventHelper.customEvent
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
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeEventProperty>.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      CreateEnvelopeSelectItems<CreateEnvelopeEventProperty>(multipleSelectionCount: 1)
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .inner(.push):
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeDate(.init(state.$createEnvelopeProperty)))
        return .none
      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.inner(.push))
        }

      case let .scope(.createEnvelopeSelectionItems(.delegate(.selected(id)))):
        let pushable = !id.isEmpty
        return .send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
      case .scope(.nextButton):
        return .none

      case .delegate:
        return .none

      case .scope(.createEnvelopeSelectionItems):
        return .none
      }
    }
  }
}
