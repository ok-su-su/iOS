//
//  InventorySearch.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryKeyword

public struct InventoryKeyword: Equatable {
  let keyword: String
  let type: InventoryType
  let date: String
}

// MARK: - InventorySearchHelper

public struct InventorySearchHelper: Equatable {
  var keyword: [InventoryKeyword] = [.init(keyword: "나의 결혼식", type: .Wedding, date: "2023.11.31-2023.12.01"), .init(keyword: "결혼식", type: .Wedding, date: "2023.11.31")]
  var latestKeyword: [String] = ["나의", "형의"]

  init() {}
  init(_ keyword: [InventoryKeyword]) {
    self.keyword = keyword
  }

  func filterByTextFiled(_ textFieldText: String) -> [InventoryKeyword] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else { return [] }
    return keyword.filter { $0.keyword.contains(regex) }
  }
}

// MARK: - InventorySearch

@Reducer
public struct InventorySearch {
  @ObservableState
  public struct State {
    var headerType = HeaderViewFeature.State(.init(title: "", type: .depth2Default))
    var inventoryTextFiled: InventorySearchTextField.State
    @Shared var searchText: String
    @Shared var searchHelper: InventorySearchHelper

    public init(searchHelper: Shared<InventorySearchHelper>) {
      _searchText = .init("")
      inventoryTextFiled = .init(text: _searchText)
      _searchHelper = searchHelper
    }

    var latestSearchCount: Int {
      return searchHelper.latestKeyword.count
    }

    var isEmptySearchHistory: Bool {
      return searchHelper.latestKeyword.isEmpty
    }

    var inventorySearchResult: [InventoryKeyword] {
      return searchHelper.filterByTextFiled(searchText)
    }
  }

  public enum Action: Equatable {
    case setHeaderView(HeaderViewFeature.Action)
    case setInventoryTextFieldView(InventorySearchTextField.Action)
    case didTapLatestSearch(String)
    case didTapKeywordDelete(String)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: \.setHeaderView) {
      HeaderViewFeature()
    }

    Scope(state: \.inventoryTextFiled, action: \.setInventoryTextFieldView) {
      InventorySearchTextField()
    }

    Reduce { state, action in
      switch action {
      case .setHeaderView:
        return .none
      case .setInventoryTextFieldView:
        return .none
      case let .didTapLatestSearch(searchText):
        state.searchText = searchText
        return .none
      case let .didTapKeywordDelete(searchText):
        var latestSearch = state.searchHelper.latestKeyword
        if let index = latestSearch.firstIndex(of: searchText) {
          latestSearch.remove(at: index)
          state.searchHelper.latestKeyword = latestSearch
        }
        return .none
      }
    }
  }
}
