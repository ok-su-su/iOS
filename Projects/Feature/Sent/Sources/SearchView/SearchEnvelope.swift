//
//  SearchEnvelope.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - SearchEnvelope

@Reducer
struct SearchEnvelope {
  @ObservableState
  struct State {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(title: "", type: .depth2Default))
    var customTextField: CustomTextField.State
    @Shared var textFieldText: String
    @Shared var searchHelper: SearchEnvelopeHelper

    init(searchHelper: Shared<SearchEnvelopeHelper>) {
      _textFieldText = .init("")
      customTextField = .init(text: _textFieldText)
      _searchHelper = searchHelper
    }

    var latestSearchCount: Int {
      return searchHelper.latestSearch.count
    }

    var isEmptySearchHistory: Bool {
      return searchHelper.latestSearch.isEmpty
    }

    var searchResult: [SentPerson] {
      return searchHelper.filterByTextField(textFieldText)
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
    case tappedLatestSearchName(String)
    case tappedLatestSearchNameDelete(String)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.customTextField, action: \.customTextField) {
      CustomTextField()
    }

    Reduce { state, action in
      switch action {
      case let .tappedLatestSearchNameDelete(name):
        var latestSearch = state.searchHelper.latestSearch
        if let ind = latestSearch.firstIndex(of: name) {
          latestSearch.remove(at: ind)
          state.searchHelper.latestSearch = latestSearch
        }
        return .none
      case let .tappedLatestSearchName(name):
        state.textFieldText = name
        return .none
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .header:
        return .none
      case .customTextField:
        return .none
      }
    }
  }
}
