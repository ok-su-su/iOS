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
import SSSelectableItems

@Reducer
public struct CreateEnvelopeAdditionalIsVisitedEvent {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var pushable = false
    @Shared var isVisitedEventHelper: CreateEnvelopeAdditionalIsVisitedEventHelper

    var createEnvelopeSelectionItems: SSSelectableItemsReducer<CreateEnvelopeAdditionalIsVisitedEventProperty>.State
    var eventName = CreateEnvelopeRequestShared.getCategoryName()

    init(isVisitedEventHelper: Shared<CreateEnvelopeAdditionalIsVisitedEventHelper>) {
      _isVisitedEventHelper = isVisitedEventHelper
      createEnvelopeSelectionItems = .init(
        items: isVisitedEventHelper.items,
        selectedID: isVisitedEventHelper.selectedID,
        isCustomItem: .init(nil)
      )
      reset()
    }

    mutating func reset() {
      isVisitedEventHelper.reset()
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

  public enum InnerAction: Equatable {
    case push
  }

  public enum AsyncAction: Equatable {}

  @CasePathable
  public enum ScopeAction: Equatable {
    case createEnvelopeSelectionItems(SSSelectableItemsReducer<CreateEnvelopeAdditionalIsVisitedEventProperty>.Action)
  }

  public enum DelegateAction: Equatable {}

  public var body: some Reducer<State, Action> {
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      SSSelectableItemsReducer<CreateEnvelopeAdditionalIsVisitedEventProperty>()
    }
    Reduce { state, action in
      switch action {
      case .view(.tappedNextButton):
        return .send(.inner(.push))

      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .isVisitedEvent)
        let isVisited = state.isVisitedEventHelper.isVisited
        CreateEnvelopeRequestShared.setIsVisited(isVisited)
        return .none

      case let .scope(.createEnvelopeSelectionItems(.delegate(.selected(id: id)))):
        let pushable = !id.isEmpty
        state.pushable = pushable
        return .none

      case .scope(.createEnvelopeSelectionItems):
        return .none
      }
    }
  }
}
