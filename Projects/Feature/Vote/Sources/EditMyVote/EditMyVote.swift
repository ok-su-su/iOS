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

// MARK: - EditMyVote

@Reducer
struct EditMyVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "투표 편집", type: .depth2Text("등록")))
    var voteDetailProperty: VoteDetailProperty
    var headerSectionItem: [VoteSectionHeaderItem] = []
    var selectedHeaderSectionItem: VoteSectionHeaderItem? = nil
    var textFieldText: String = ""
    init(voteDetailProperty: VoteDetailProperty) {
      self.voteDetailProperty = voteDetailProperty
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
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.textFieldText = state.voteDetailProperty.content
      state.isOnAppear = isAppear
      guard let headerSectionItem: [VoteSectionHeaderItem] = VoteMemoryCache.value() else{
        return .send(.async(.getVoteHeaderSectionItems))
      }
      state.headerSectionItem = headerSectionItem
      return .none
    case let .editedVoteTextContent(text):
      state.textFieldText = text
      return .none
    case let .tappedSection(item):
      state.selectedHeaderSectionItem = item
      return .none
    }
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {
    case getVoteHeaderSectionItems
  }
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getVoteHeaderSectionItems:
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }
  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedTextButton):
      return .none
    case .header:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    initScope
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where State == EditMyVote.State, Action == EditMyVote.Action {
  var initScope: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
  }
}
