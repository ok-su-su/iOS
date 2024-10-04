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
struct WriteVote: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var header: HeaderViewFeature.State
    var helper: WriteVoteProperty = .init()
    /// TextFieldWithTCA Reducer.State
    var selectableItems: IdentifiedArrayOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>.State>
    let type: WriteVoteType

    var isCreatable: Bool { helper.isCreatable }
    var mutex: TCATaskManager = .init()
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

    /// 만약 Edit Mode일 경우 Initial 함수를 통해서 입력받습니다..
    fileprivate let voteID: Int64?

    /// WriteVote State Initial Function
    init(sectionHeaderItems: [VoteSectionHeaderItem]) {
      voteID = nil
      header = .init(.init(title: "새 투표 작성", type: .depth2Default))
      selectableItems = .init(uniqueElements: [])
      type = .create
      helper.updateHeaderSectionItem(items: sectionHeaderItems)
      setSelectableItemsState()
    }

    /// EditVote State Initial Function
    init(
      type: WriteVoteType,
      voteId: Int64,
      sectionHeaderItems: [VoteSectionHeaderItem],
      selectedHeaderItemID: Int,
      content: String,
      selectableItemsProperty: [TextFieldButtonWithTCAProperty]
    ) {
      self.type = type
      voteID = voteId
      header = .init(.init(title: "투표 편집", type: .depth2Default))
      selectableItems = .init(uniqueElements: [])
      helper.updateHeaderSectionItem(items: sectionHeaderItems, selectedID: selectedHeaderItemID)
      helper.voteTextContent = content
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

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedSection(VoteSectionHeaderItem)
    case editedVoteTextContent(String)
    case tappedAddSectionItemButton
    case tappedCreateButton
    case tappedUnavailableEditSectionItem
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
        ? .send(.scope(.toast(.showToastMessage(Constants.textFieldOverFlowToastMessage))))
        : .none

    case .tappedAddSectionItemButton:
      state.helper.addNewItem()
      state.setSelectableItemsState()
      return .none

    case .tappedCreateButton:
      switch state.type {
      case .create:
        return .send(.async(.writeVote))
      case .editAll,
           .editOnlyContent:
        return .send(.async(.updateVote))
      }
    case .tappedUnavailableEditSectionItem:
      return .send(.scope(.toast(.showToastMessage(Constants.unavailableButtonToastMessage))))
    }
  }

  enum InnerAction: Equatable, Sendable {}

  @Dependency(\.writeVoteNetwork) var network
  @Dependency(\.dismiss) var dismiss
  enum AsyncAction: Equatable, Sendable {
    case writeVote
    case updateVote
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

      return .ssRun { _ in
        let response = try await network.createVote(request)
        VotePathPublisher.shared.push(.createVoteAndPushDetail(.init(createdBoardID: response.id)))
      }
    case .updateVote:
      guard let voteID = state.voteID,
            let selectedSectionID = state.helper.selectedSection?.id
      else {
        return .none
      }
      let content = state.helper.voteTextContent
      let updateVoteRequestBody = UpdateVoteRequestBody(boardID: selectedSectionID, content: content)
      return .ssRun { _ in
        let response = try await network.updateVote(voteID, updateVoteRequestBody)
        VotePathPublisher.shared.push(.createVoteAndPushDetail(.init(createdBoardID: response.id)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
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

  enum DelegateAction: Equatable, Sendable {}

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

// MARK: - WriteVote.Constants

extension WriteVote {
  enum WriteVoteType: Equatable {
    case create
    case editOnlyContent
    case editAll
  }

  private enum Constants {
    static let textFieldOverFlowToastMessage = "글은 200자 이내로 등록할 수 있어요!"
    static let unavailableButtonToastMessage = "시작된 투표는 보기를 편집할 수 없어요"
  }
}
