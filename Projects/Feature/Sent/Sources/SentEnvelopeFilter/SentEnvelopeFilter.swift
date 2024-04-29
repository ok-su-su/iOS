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
import SwiftUI

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
    var ssButtonProperties: [SSButtonPropertyState] = []
    var sliderProperty: CustomSlider = .init(start: 0, end: 100_000, width: UIScreen.main.bounds.size.width - 42)
    init(sentPeople: [SentPerson]) {
      self.sentPeople = sentPeople
      sentPeople.forEach { sentPerson in
        ssButtonProperties.append(
          .init(
            size: .xsh28,
            status: .inactive,
            style: .lined,
            color: .black,
            buttonText: sentPerson.name
          )
        )
      }
    }
  }

  enum Action: BindableAction, Equatable {
    case onAppear(Bool)
    case binding(BindingAction<State>)
    case header(HeaderViewFeature.Action)
    case tappedButton
    case tappedPerson(Int)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .tappedPerson:
        return .none
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
