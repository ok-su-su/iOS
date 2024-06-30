//
//  ReceivedSearch.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSSearch

// MARK: - ReceivedSearch

@Reducer
struct ReceivedSearch {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false

    // Scope State
    @Shared var searchProperty: ReceivedSearchProperty
    var search: SSSearchReducer<ReceivedSearchProperty>.State
    var path: StackState<LedgerDetailPath.State> = .init()
    var header: HeaderViewFeature.State = .init(.init(type: .depth2NonIconType))
    init() {
      _searchProperty = .init(.default)
      search = .init(helper: _searchProperty)
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
    case search(SSSearchReducer<ReceivedSearchProperty>.Action)
    case path(StackActionOf<LedgerDetailPath>)
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { _, action in
    switch action {
    case .search:
      return .none
    case .path:
      return .none
    case .header:
      return .none
    }
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { _, _ in
    return .none
  }

  var asyncAction: (_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> = { _, _ in
    return .none
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == ReceivedSearch.State, Self.Action == ReceivedSearch.Action {}

// MARK: - ReceivedSearchProperty

struct ReceivedSearchProperty: SSSearchPropertiable {
  typealias item = ReceivedSearchItem
  var prevSearchedItem: [ReceivedSearchItem]
  var nowSearchedItem: [ReceivedSearchItem]
  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var textFieldText: String
  var iconType: SSSearch.SSSearchIconType
  var noSearchResultTitle: String
  var noSearchResultDescription: String

  init(
    prevSearchedItem: [ReceivedSearchItem],
    nowSearchedItem: [ReceivedSearchItem],
    textFieldPromptText: String,
    prevSearchedNoContentTitleText: String,
    prevSearchedNoContentDescriptionText: String,
    textFieldText: String,
    iconType: SSSearchIconType,
    noSearchResultTitle: String,
    noSearchResultDescription: String
  ) {
    self.prevSearchedItem = prevSearchedItem
    self.nowSearchedItem = nowSearchedItem
    self.textFieldPromptText = textFieldPromptText
    self.prevSearchedNoContentTitleText = prevSearchedNoContentTitleText
    self.prevSearchedNoContentDescriptionText = prevSearchedNoContentDescriptionText
    self.textFieldText = textFieldText
    self.iconType = iconType
    self.noSearchResultTitle = noSearchResultTitle
    self.noSearchResultDescription = noSearchResultDescription
  }
}

extension ReceivedSearchProperty {
  static var `default`: Self {
    .init(
      prevSearchedItem: [],
      nowSearchedItem: [],
      textFieldPromptText: "찾고 싶은 장부를 검색해보세요",
      prevSearchedNoContentTitleText: "어떤 장부를 찾아드릴까요?",
      prevSearchedNoContentDescriptionText: "장부 이름, 경조사 카테고리 등을\n검색해볼 수 있어요",
      textFieldText: "",
      iconType: .inventory,
      noSearchResultTitle: "원하는 검색 결과가 없나요?",
      noSearchResultDescription: "장부 이름, 경조사 카테고리 등을\n검색해볼 수 있어요"
    )
  }
}

// MARK: - ReceivedSearchItem

struct ReceivedSearchItem: SSSearchItemable {
  /// 장부의 아이디 입니다.
  var id: Int64
  /// 장부의 이름 입니다.
  var title: String
  /// 장부의 카테고리 입니다.
  var firstContentDescription: String?
  /// 장부의 날짜 입니다.
  var secondContentDescription: String?
}
