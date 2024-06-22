//
//  CreateEnvelopeAdditionalIsVisitedEvent.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

@Reducer
struct CreateEnvelopeAdditionalIsVisitedEvent {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var isVisitedEventHelper: CreateEnvelopeAdditionalIsVisitedEventHelper

    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeAdditionalIsVisitedEventProperty>.State
    var nextButton = CreateEnvelopeBottomOfNextButton.State()

    init(isVisitedEventHelper: Shared<CreateEnvelopeAdditionalIsVisitedEventHelper>) {
      _isVisitedEventHelper = isVisitedEventHelper
      createEnvelopeSelectionItems = .init(
        items: isVisitedEventHelper.items,
        selectedID: isVisitedEventHelper.selectedID,
        isCustomItem: .init(nil)
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
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeAdditionalIsVisitedEventProperty>.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      // TODO: 다른 로직 생각
      CreateEnvelopeSelectItems<CreateEnvelopeAdditionalIsVisitedEventProperty>()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .isVisitedEvent)
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .send(.inner(.push))

      case .scope(.nextButton):
        return .none

      case let .scope(.createEnvelopeSelectionItems(.delegate(.selected(id: id)))):
        let pushable = !id.isEmpty
        return .send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))

      case .scope(.createEnvelopeSelectionItems):
        return .none
      }
    }
  }
}
