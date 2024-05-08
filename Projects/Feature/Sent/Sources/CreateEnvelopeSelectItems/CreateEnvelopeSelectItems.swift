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
    @Shared var items: [Item]
    @Shared var selectedID: [UUID]
    init(items: Shared<[Item]>, selectedID: Shared<[UUID]>) {
      _items = items
      _selectedID = selectedID
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
    case tappedItem(id: UUID)
  }

  enum InnerAction: Equatable {}

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
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

        // MARK: - 사용자가 버튼을 눌렀을 경우에

      case let .view(.tappedItem(id)):
        // 만약 누른 버튼이 있는 경우에 deselected합니다.
        if state.selectedID.contains(id) {
          state.selectedID = state.selectedID.filter { $0 != id }
        } else { // not contains
          let ccc = state.selectedID.count.description
          if state.selectedID.count + 1 <= multipleSelectionCount {
            state.selectedID.append(id)
          } else {
            // TODO: Some Logic to depend multipleSelection
          }
        }
        let currentSelectedID = state.selectedID
        return .run { send in
          await send(.delegate(.selected(id: currentSelectedID)))
        }
      case .delegate(.selected):
        return .none
      }
    }
  }
}
