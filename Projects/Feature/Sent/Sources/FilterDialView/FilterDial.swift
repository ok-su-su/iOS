//
//  FilterDial.swift
//  Sent
//
//  Created by MaraMincho on 4/30/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

@Reducer
struct FilterDial {
  @Dependency(\.dismiss) var dismiss
  @ObservableState
  struct State {
    var isOnAppear = false
    @Shared var filterDialProperty: FilterDialProperty

    init(filterDialProperty: Shared<FilterDialProperty>) {
      _filterDialProperty = filterDialProperty
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tappedDial(FilterDialType)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none

      case let .tappedDial(type):
        state.filterDialProperty.currentType = type
        return .run { _ in
          await dismiss()
        }
      }
    }
  }
}
