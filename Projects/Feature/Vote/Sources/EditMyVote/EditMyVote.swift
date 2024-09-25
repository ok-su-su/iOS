//
//  EditMyVote.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSRegexManager
import SSToast

// MARK: - EditMyVote

@Reducer
struct EditMyVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "투표 편집", type: .defaultType))
    var voteDetailProperty: VoteDetailProperty
    var headerSectionItem: [VoteSectionHeaderItem] = []
    var selectedHeaderSectionItem: VoteSectionHeaderItem? = nil
    var textFieldText: String = ""
    var isLoading: Bool = true
    var toast: SSToastReducer.State = .init(.init(toastMessage: DefaultToastMessage.voteContent.message, trailingType: .none))

    var isEditConfirmable: Bool {
      RegexManager.isValidVoteContent(textFieldText)
    }

    init(voteDetailProperty: VoteDetailProperty) {
      self.voteDetailProperty = voteDetailProperty
      textFieldText = voteDetailProperty.content
      headerSectionItem = VoteMemoryCache.value() ?? []
      selectedHeaderSectionItem = headerSectionItem.first(where: { $0.id == voteDetailProperty.board.id })
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
    case editedVoteTextContent(String)
    case tappedSection(VoteSectionHeaderItem)
    case tappedEditConfirmButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear

      return state.headerSectionItem.isEmpty ?
        .send(.async(.getVoteHeaderSectionItems)) :
        .send(.inner(.isLoading(false)))

    case let .editedVoteTextContent(text):
      state.textFieldText = text
      return ToastRegexManager.isShowToastVoteContent(text) ?
        .send(.scope(.toast(.onAppear(true)))) :
        .none

    case let .tappedSection(item):
      state.selectedHeaderSectionItem = item
      return .none
    case .tappedEditConfirmButton:
      return .ssRun { _ in
        await dismiss()
      }
    }
  }

  enum InnerAction: Equatable {
    case updateSectionHeaderItems([VoteSectionHeaderItem])
    case isLoading(Bool)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateSectionHeaderItems(items):
      state.headerSectionItem = items
      state.selectedHeaderSectionItem = items.first(where: { $0.id == state.voteDetailProperty.board.id })
      return .none
    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  @Dependency(\.voteEditNetwork) var network
  @Dependency(\.dismiss) var dismiss
  enum AsyncAction: Equatable {
    case getVoteHeaderSectionItems
  }

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getVoteHeaderSectionItems:
      return .ssRun { send in
        let items = try await network.getVoteCategory()
        await send(.inner(.updateSectionHeaderItems(items)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .toast:
      return .none
    case .header:
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
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where State == EditMyVote.State, Action == EditMyVote.Action {}
