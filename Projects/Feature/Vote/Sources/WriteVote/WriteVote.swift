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
import SSRegexManager
import SSToast

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

    var isCreatable: Bool { helper.isCreatable }
    var mutex: TCAMutexManager = .init()
    var toast: SSToastReducer.State = .init(.init(toastMessage: "글은 200자 이내로 등록할 수 있어요!", trailingType: .none))
    var editVoteType: EditVoteType? = nil

    /// WriteVote State Initial Function
    init(sectionHeaderItems: [VoteSectionHeaderItem]) {
      selectableItems = .init(uniqueElements: [])
      helper.updateHeaderSectionItem(items: sectionHeaderItems)
      setSelectableItemsState()
    }

    /// EditVote State Initial Function
    init(
      sectionHeaderItems: [VoteSectionHeaderItem],
      selectedHeaderItemID: Int,
      content: String,
      selectableItemsProperty: [TextFieldButtonWithTCAProperty],
      editVoteType: EditVoteType
    ) {
      selectableItems = .init(uniqueElements: [])
      helper.updateHeaderSectionItem(items: sectionHeaderItems, selectedID: selectedHeaderItemID)
      helper.voteTextContent = content
      self.editVoteType = editVoteType
      helper.selectableItem = .init(uniqueElements: selectableItemsProperty)
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
      return ToastRegexManager.isShowToastVoteContent(text)
        ? .send(.scope(.toast(.onAppear(true))))
        : .none

    case .tappedAddSectionItemButton:
      state.helper.addNewItem()
      state.setSelectableItemsState()
      return .none

    case .tappedCreateButton:
      return .send(.async(.writeVote))
    }
  }

  enum InnerAction: Equatable {}

  @Dependency(\.writeVoteNetwork) var network
  enum AsyncAction: Equatable {
    case writeVote
  }

  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .writeVote:
      guard let selectedSectionID = state.helper.selectedSection?.id else {
        return .none
      }
      let options = state.helper.getVoteOptionModel()
      let request = CreateVoteRequestBody(
        content: state.helper.voteTextContent,
        options: options,
        boardId: selectedSectionID
      )

      return .run { _ in
        let response = try await network.createVote(request)
        VotePathPublisher.shared.push(.createVoteAndPushDetail(.init(createdBoardID: response.id)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case selectableItems(IdentifiedActionOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>>)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .toast:
      return .none
    case .header:
      return .none

    case let .selectableItems(.element(id: id, action: .deleteComponent)):
      state.deleteSelectableItemsState(id: id)
      return .none
    case .selectableItems(.element(id: _, action: _)):
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case let .scope(currentAction):
        return scopeAction(&state, currentAction)

      case let .async(currentAction):
        return asyncAction(&state, currentAction)
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

// MARK: - EditVoteType

enum EditVoteType {
  case editVoteContentOnly
  case editVoteContentAndSelectableSection
}
