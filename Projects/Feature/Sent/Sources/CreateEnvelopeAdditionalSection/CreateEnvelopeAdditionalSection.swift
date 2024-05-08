//
//  CreateEnvelopeAdditionalSection.swift
//  Sent
//
//  Created by MaraMincho on 5/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct CreateEnvelopeAdditionalSection {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isAddingNewItem: Bool = false

    var isSavedCustomItem: Bool = false
    var selectedItem: [String] { return createEnvelopeProperty.createEnvelopeAdditionalSectionManager.selectedItemTitles }

    var defaultItems: [String] { return createEnvelopeProperty.createEnvelopeAdditionalSectionManager.defaultItemTitles }

    var isAbleToPush: Bool { return createEnvelopeProperty.createEnvelopeAdditionalSectionManager.isSelected() }
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
  }

  enum InnerAction: Equatable {}

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
        if state.selectedItem.contains(name) {
          state.createEnvelopeProperty.createEnvelopeAdditionalSectionManager.removeItem(name)
        } else {
          state.createEnvelopeProperty.createEnvelopeAdditionalSectionManager.addItem(name)
        }

        return .none

      case .view(.tappedNextButton):
        return .run { send in
          await send(.delegate(.push))
        }

      case .delegate:
        return .none

      case .binding:
        return .none
      }
    }
  }
}
