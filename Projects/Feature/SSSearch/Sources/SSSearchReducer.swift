//
//  SSSearch.swift
//  SSSearch
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
public struct SSSearchReducer<item: SSSearchPropertiable>: Sendable {
  public init() {}

  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    @Shared var helper: item
    public init(helper: Shared<item>) {
      _helper = helper
    }
  }

  public enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case tappedCloseButton
    case changeTextField(String)
    case tappedPrevItem(id: Int64)
    case tappedDeletePrevItem(id: Int64)
    case tappedSearchItem(id: Int64)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .tappedCloseButton:
        state.helper.textFieldText = ""
        return .none
      case let .changeTextField(text):
        state.helper.textFieldText = text
        return .none
      case .tappedPrevItem(id: _):
        return .none
      case .tappedDeletePrevItem(id: _):
        return .none
      case .tappedSearchItem(id: _):
        return .none
      }
    }
  }
}
