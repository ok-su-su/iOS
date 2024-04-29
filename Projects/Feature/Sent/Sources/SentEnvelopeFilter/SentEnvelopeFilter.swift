//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var textFieldText: String = ""
    var isHighlight: Bool = true
    var sentPeople: [SentPerson]
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    init(sentPeople: [SentPerson]) {
      self.sentPeople = sentPeople
    }
  }

  enum Action: BindableAction, Equatable {
    case onAppear(Bool)
    case binding(BindingAction<State>)
    case header(HeaderViewFeature.Action)
    case tappedButton
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .tappedButton:
        return .none
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }

  init() {}
}

// MARK: - SentPerson

struct SentPerson: Identifiable {
  let id = UUID()
  let name: String
  init(name: String) {
    self.name = name
  }
}
