//
//  VoteSearch.swift
//  Vote
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSSearch

// MARK: - VoteSearch

@Reducer
struct VoteSearch {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var helper: VoteSearchProperty
    var header: HeaderViewFeature.State = .init(.init(type: .depth2Default))
    var searchReducer: SSSearchReducer<VoteSearchProperty>.State

    init() {
      _helper = Shared(.init())
      searchReducer = .init(helper: _helper)
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
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear

      // set PrevItems
      state.helper.prevSearchedItem = VoteSearchPersistence.getPrevVoteSearchItems()
      return .none
    }
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case searchReducer(SSSearchReducer<VoteSearchProperty>.Action)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case let .searchReducer(.changeTextField(text)):
      // changeTextField
//        state.helper.searchItem(by: text)
      return .none
    case let .searchReducer(.tappedDeletePrevItem(id: id)):
      state.helper.deletePrevItem(prevItemID: id)
      return .none

    case let .searchReducer(.tappedPrevItem(id: id)):
      let title = state.helper.titleByPrevItem(id: id)
      return .send(.scope(.searchReducer(.changeTextField(title))))

    case let .searchReducer(.tappedPrevItem(id)):
      return .none

    case .searchReducer:
      return .none

    case .header:
      return .none
    }
  }

  func searchAction(_ state: inout State, _ action: SSSearchReducer<VoteSearchProperty>.Action) -> Effect<Action> {
    switch action {
    case let  .onAppear(bool):
      return .none
    case .tappedCloseButton:
      return .none

    case let .changeTextField(string):
      // TODO: Network 검색 기능 추가
      return .none

    case let .tappedPrevItem(id):
      VotePathPublisher.shared.push(.detail(.init(id: id)))
      return .none

    case let .tappedDeletePrevItem(id):
      VoteSearchPersistence.deletePrevVoteSearchItemsByID(id)
      state.helper.prevSearchedItem = VoteSearchPersistence.getPrevVoteSearchItems()
      return .none

    case let .tappedSearchItem(id):
      if let targetItem = state.helper.nowSearchedItem.first(where: {$0.id == id}) {
        VoteSearchPersistence.setPrevVoteSearchItems(targetItem)
      }
      VotePathPublisher.shared.push(.detail(.init(id: id)))
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.searchReducer, action: \.scope.searchReducer) {
      SSSearchReducer()
    }
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}
