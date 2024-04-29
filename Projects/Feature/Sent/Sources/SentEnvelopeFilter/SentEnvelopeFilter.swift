//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
public struct SentEnvelopeFilter {
  @ObservableState
  public struct State {
    var isOnAppear = false
  }

  public enum Action: Equatable {
    case onAppear(Bool)
  }

  public var body: some Reducer<State, Action> {
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

  public init() {}
}
