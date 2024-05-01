//
//  SearchEnvelope.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct SearchEnvelope {
  @ObservableState
  struct State {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(title: "", type: .depth2Default))
    var customTextField: CustomTextField.State
    @Shared var textFieldText: String

    init() {
      _textFieldText = .init("")
      customTextField = .init(text: _textFieldText)
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.customTextField, action: \.customTextField) {
      CustomTextField()
    }

    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .header:
        return .none
      case .customTextField:
        return .none
      }
    }
  }
}
