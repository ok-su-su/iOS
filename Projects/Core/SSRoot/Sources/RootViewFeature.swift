//
//  RootViewFeature.swift
//  SSRoot
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct RootViewFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case tapSearchButton
    case tapNotificationButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .tapSearchButton:
        return .none
      case .tapNotificationButton:
        return .none
      }
    }
  }

  public init() {}
}
