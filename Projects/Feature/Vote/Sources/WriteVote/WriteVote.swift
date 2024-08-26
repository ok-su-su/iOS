//
//  WriteVote.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

// MARK: - WriteVote

@Reducer
struct WriteVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "새 투표 작성", type: .depth2Default))
    var helper: WriteVoteProperty = .init()
    /// TextFieldWithTCA Reducer.State
    var selectableItems: IdentifiedArrayOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>.State>

    var isCreatable: Bool {
      false
    }

    init(sectionHeaderItems: [VoteSectionHeaderItem]) {
      selectableItems = .init(uniqueElements: [])
      helper.updateHeaderSectionItem(items: sectionHeaderItems)
      setSelectableItemsState()
    }

    mutating func setSelectableItemsState() {
      selectableItems = []
      helper.selectableItem.forEach { property in
        guard let sharedProperty = Shared(helper.$selectableItem[id: property.id]) else {
          return
        }
        selectableItems.append(.init(sharedItem: sharedProperty))
      }
    }

    mutating func deleteSelectableItemsState(id: Int) {
      guard helper.selectableItem.count > 2 else {
        return
      }
      selectableItems = selectableItems.filter { $0.id != id }
      helper.selectableItem = helper.selectableItem.filter { $0.id != id }
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedSection(VoteSectionHeaderItem)
    case editedVoteTextContent(String)
    case tappedAddSectionItemButton
    case tappedCreateButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .none

    case let .tappedSection(item):
      state.helper.selectedSection = item
      return .none

    case let .editedVoteTextContent(text):
      state.helper.voteTextContent = text
      return .none

    case .tappedAddSectionItemButton:
      state.helper.addNewItem()
      state.setSelectableItemsState()
      return .none

    case .tappedCreateButton:
      // TODO: Add Create Post Logic
      return .none
    }
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case selectableItems(IdentifiedActionOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case .scope(.header):
        return .none

      case let .scope(.selectableItems(.element(id: id, action: .deleteComponent))):
        state.deleteSelectableItemsState(id: id)
        return .none
      case .scope(.selectableItems(.element(id: _, action: _))):
        return .none
      }
    }
    .addFeatures0()
  }
}

private extension Reducer where State == WriteVote.State, Action == WriteVote.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.selectableItems, action: \.scope.selectableItems) {
      TextFieldButtonWithTCA()
    }
  }
}
