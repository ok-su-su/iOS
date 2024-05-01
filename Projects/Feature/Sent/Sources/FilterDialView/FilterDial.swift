//
//  FilterDial.swift
//  Sent
//
//  Created by MaraMincho on 4/30/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct FilterDial {
  @ObservableState
  struct State {
    var isOnAppear = false
    var filterDialProperty: FilterDialProperty

    init(filterDialProperty: FilterDialProperty) {
      self.filterDialProperty = filterDialProperty
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
