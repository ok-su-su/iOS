//
//  CreateEnvelopeSelectItems.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
struct CreateEnvelopeSelectItems<Item: CreateEnvelopeSelectItemable> {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var customTitleText: String = ""
    @Shared var isCustomItem: Item?
    @Shared var items: [Item]
    @Shared var selectedID: [UUID]

    var customRelationSaved: Bool = false
    var isAddingNewRelation: Bool = false

    init(items: Shared<[Item]>, selectedID: Shared<[UUID]>, isCustomItem: Shared<Item?>) {
      _items = items
      _selectedID = selectedID
      _isCustomItem = isCustomItem
    }
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
    case tappedItem(id: UUID)
    case tappedAddCustomRelation
    case tappedTextFieldCloseButton
    case tappedTextFieldSaveAndEditButton
  }

  enum InnerAction: Equatable {
    case singleSelection(id: UUID)
    case multipleSelection(id: UUID)
    case startAddCustomRelation
    case endAddCustomRelation
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {
    case selected(id: [UUID])
  }

  var multipleSelectionCount = 1

  init(multipleSelectionCount: Int = 1) {
    self.multipleSelectionCount = multipleSelectionCount
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

        // MARK: - 사용자가 버튼을 눌렀을 경우에

      case let .view(.tappedItem(id)):

        // MARK: - 이미 선택된 버튼일 때

        if state.selectedID.contains(id) {
          state.selectedID = state.selectedID.filter { $0 != id }
          let curSelected = state.selectedID
          return .run { send in
            await send(.delegate(.selected(id: curSelected)))
          }
        }

        // MARK: - 한개의 버튼을 선택하는 화면일 때

        else if multipleSelectionCount == 1 {
          return .run { send in
            await send(.inner(.singleSelection(id: id)))
          }
        }

        // MARK: - 여러개의 버튼을 선택할 수 있을 때

        return .run { send in
          await send(.inner(.multipleSelection(id: id)))
        }

      case .delegate(.selected):
        return .none

      case let .inner(.singleSelection(id)):
        state.selectedID = [id]
        let curSelection = state.selectedID
        return .run { send in
          await send(.delegate(.selected(id: curSelection)))
        }

      case let .inner(.multipleSelection(id)):
        if state.selectedID.count + 1 <= multipleSelectionCount {
          state.selectedID.append(id)
        }
        // TODO: Some Logic to depend multiple Selection
        else {}
        let curSelection = state.selectedID
        return .run { send in
          await send(.delegate(.selected(id: curSelection)))
        }
      case .binding:
        return .none

      case .view(.tappedAddCustomRelation):
        return .run { send in
          await send(.inner(.startAddCustomRelation))
        }

      case .view(.tappedTextFieldCloseButton):
        state.customTitleText = ""
        if state.customRelationSaved {
          return .run { send in
            await send(.inner(.endAddCustomRelation))
          }
        }
        return .none

      case .view(.tappedTextFieldSaveAndEditButton):
        state.customRelationSaved.toggle()
        state.isCustomItem?.setTitle(state.customTitleText)
        return .none

      case .inner(.startAddCustomRelation):
        state.isAddingNewRelation = true
        state.customTitleText = ""
        state.customRelationSaved = false
        return .none

      case .inner(.endAddCustomRelation):
        state.isAddingNewRelation = false
        return .none
      }
    }
  }
}
