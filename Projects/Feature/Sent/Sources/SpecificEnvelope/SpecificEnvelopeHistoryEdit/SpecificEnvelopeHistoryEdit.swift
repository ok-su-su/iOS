// 
//  SpecificEnvelopeHistoryEdit.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture

@Reducer
struct SpecificEnvelopeHistoryEdit {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    
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
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
