// 
//  CreateEnvelopeNavigation.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture

@Reducer
public struct CreateEnvelopeNavigation {

  @ObservableState
  public struct State {
    var isOnAppear = false
  }

  public enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }
  
  public enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  public enum InnerAction: Equatable {}

  public enum AsyncAction: Equatable {}

  @CasePathable
  public enum ScopeAction: Equatable {}

  public enum DelegateAction: Equatable {}

  public var body: some Reducer<State, Action> {
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
  
  public init() {}
}
