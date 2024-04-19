//
//  SentMain.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Foundation


@Reducer
struct SentMain {
  @ObservableState
  struct State {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
