// 
//  SSSelectableItems.swift
//  SSSelectableItems
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture
import FeatureAction

@Reducer
public struct SSSelectableItemsReducerReducer {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isInited = false
    init () {}
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
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)) :
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .none
      }
    }
  }
}
