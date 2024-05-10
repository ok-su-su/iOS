// 
//  EnvelopePriceProgress.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture

@Reducer
struct EnvelopePriceProgress {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var progressValue: Double = 150
    init () {}
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case updatePropery
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
      case let .onAppear(isAppear) :
        state.isOnAppear = isAppear
        return .none
      }
    }
  }
}
