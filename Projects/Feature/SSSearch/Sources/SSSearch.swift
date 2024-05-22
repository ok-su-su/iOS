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
public struct SSSearchReducer<item: SSSearchPropertiable> {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var helper: item
  }

  public enum Action: Equatable {
    case onAppear(Bool)
    case tappedCloseButton
    case changeTextField(String)
    case tappedPrevItem(id: Int)
    case tappedDeletePrevItem(id: Int)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .tappedCloseButton:
        return .none
      case .changeTextField:
        return .none
      case let .tappedPrevItem(id: id):
        return .none
      case let .tappedDeletePrevItem(id: id):
        return .none
      }
    }
  }
}
