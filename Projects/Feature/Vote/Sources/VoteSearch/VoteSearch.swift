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

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case searchReducer(SSSearchReducer<VoteSearchProperty>.Action)
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
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear

        // set PrevItems
        state.helper.prevSearchedItem = VoteSearchPersistence.getPrevVoteSearchItems()
        return .none

      case let .scope(.searchReducer(.changeTextField(text))):
        // changeTextField
//        state.helper.searchItem(by: text)
        return .none

      case let .scope(.searchReducer(.tappedDeletePrevItem(id: id))):
        state.helper.deletePrevItem(prevItemID: id)
        return .none

      case let .scope(.searchReducer(.tappedPrevItem(id: id))):
        let title = state.helper.titleByPrevItem(id: id)
        return .send(.scope(.searchReducer(.changeTextField(title))))

      case .scope(.searchReducer):
        return .none

      case .scope(.header):
        return .none
      }
    }
  }
}
