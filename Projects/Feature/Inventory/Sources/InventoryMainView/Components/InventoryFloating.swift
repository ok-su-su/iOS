//
//  InventoryFloating.swift
//  SSRoot
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

@Reducer
public struct InventoryFloating {
  public init() {}
  @ObservableState
  public struct State {
    var isTapped = false
  }
  
  public enum Action {
    case didTapFloatingButton
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .didTapFloatingButton:
        return .none
      }
    }
  }
  
}
