//
//  ContentViewFeature.swift
//  susu
//
//  Created by MaraMincho on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct ContentViewFeature {
  @ObservableState
  struct State: Equatable, Hashable {
    var sectionType: SSTabType = .envelope
  }

  enum Action {
    case tapSectionButton(SSTabType)
    case onAppear
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case let .tapSectionButton(type):
        switch type {
        case .envelope:
          state.sectionType = .envelope
          return .none
        case .inventory:
          state.sectionType = .inventory
          return .none
        case .statistics:
          state.sectionType = .statistics
          return .none
        case .vote:
          state.sectionType = .vote
          return .none
        case .mypage:
          state.sectionType = .mypage
          return .none
        }
      }
    }
  }
}
