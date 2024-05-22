//
//  VoteSearch.swift
//  Vote
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
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
      let helper = VoteSearchProperty()
      _helper = Shared(helper)
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
        state.isOnAppear = isAppear
        return .none

      case let .scope(.searchReducer(.changeTextField(text))):
        state.helper.searchItem(by: text)
        return .none

      case let .scope(.searchReducer(.tappedDeletePrevItem(id: id))):
        state.helper.deletePrevItem(prevItemID: id)
        return .none

      case let .scope(.searchReducer(.tappedPrevItem(id: id))):
        return .none

      case let .scope(.searchReducer(.tappedSearchItem(id: id))):
        return .none

      case .scope(.searchReducer):
        return .none

      case .scope(.header):
        return .none
      }
    }
  }
}

// MARK: - VoteSearchItem

struct VoteSearchItem: SSSearchItemable {
  var id: Int
  var title: String
  var firstContentDescription: String?
  var secondContentDescription: String?
}

// MARK: - VoteSearchProperty

struct VoteSearchProperty: SSSearchPropertiable {
  typealias item = VoteSearchItem

  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var noSearchResultTitle: String
  var noSearchResultDescription: String
  var iconType: SSSearchIconType

  mutating func searchItem(by _: String) {}
  mutating func deletePrevItem(prevItemID _: Int) {}

  var textFieldText: String = ""
  var prevSearchedItem: [VoteSearchItem] = []
  var nowSearchedItem: [VoteSearchItem] = []

  init(
    textFieldPromptText: String,
    prevSearchedNoContentTitleText: String,
    prevSearchedNoContentDescriptionText: String,
    noSearchResultTitle: String,
    noSearchResultDescription: String,
    iconType: SSSearchIconType
  ) {
    self.textFieldPromptText = textFieldPromptText
    self.prevSearchedNoContentTitleText = prevSearchedNoContentTitleText
    self.prevSearchedNoContentDescriptionText = prevSearchedNoContentDescriptionText
    self.noSearchResultTitle = noSearchResultTitle
    self.noSearchResultDescription = noSearchResultDescription
    self.iconType = iconType
  }

  init() {
    textFieldPromptText = "찾고 싶은 투표를 검색해보세요"
    prevSearchedNoContentTitleText = "어떤 투표를 찾아드릴까요?"
    prevSearchedNoContentDescriptionText = "궁금하신 것들의 키워드를\n검색해볼 수 있어요"
    noSearchResultTitle = "원하는 검색 결과가 없나요?"
    noSearchResultDescription = "SomeTing"
    iconType = .vote
  }
}
