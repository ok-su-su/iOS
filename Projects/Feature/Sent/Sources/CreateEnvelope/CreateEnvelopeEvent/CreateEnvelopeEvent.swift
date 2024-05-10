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
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var selectedString: String? = nil
    var isAddingNewItem: Bool = false

    var addingCustomItemText = ""
    var isSavedCustomItem: Bool = false

    var isAvailableAddingCustomItemSaveButton: Bool {
      return addingCustomItemText != ""
    }

    var isAbleToPush: Bool {
      return selectedString != "" && selectedString != nil
    }

    var defaultRelationString: [String] = [
      "결혼식",
      "돌잔치",
      "장례식",
      "생일기념일",
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
    case tappedItem(name: String)
    case tappedNextButton
    case tappedAddCustomItemButton
    case tappedTextFieldCloseButton
    case tappedTextFieldSaveAndEditButton
  }

  enum InnerAction: Equatable {
    case startAddCustomItem
    case endAddCustomItem
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {
    case push
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .view(.tappedItem(name: name)):
        state.selectedString = name
        return .none

      case .view(.tappedNextButton):
        return .run { send in
          await send(.delegate(.push))
        }

      case .delegate:
        return .none

      case .view(.tappedAddCustomItemButton):
        return .run { send in
          await send(.inner(.startAddCustomItem))
        }

      case .inner(.startAddCustomItem):
        state.selectedString = nil
        state.isAddingNewItem = true
        state.addingCustomItemText = ""
        state.isSavedCustomItem = false
        return .none

      case .binding:
        return .none

      case .view(.tappedTextFieldCloseButton):
        state.addingCustomItemText = ""
        if state.isSavedCustomItem {
          return .run { send in
            await send(.inner(.endAddCustomItem))
          }
        }
        return .none

      case .view(.tappedTextFieldSaveAndEditButton):
        state.isSavedCustomItem.toggle()
        return .none

      case .inner(.endAddCustomItem):
        state.isAddingNewItem = false
        return .none
      }
    }
  }
}
