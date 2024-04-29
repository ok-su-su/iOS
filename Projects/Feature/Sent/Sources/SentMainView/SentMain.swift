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
  init() {}
  @ObservableState
  struct State {
    var envelopes: IdentifiedArrayOf<Envelope.State> = [
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
    ]
    init() {}
  }

  enum Action: Equatable {
    case tappedFirstButton
    case filterButtonTapped
    case tappedEmptyEnvelopeButton
    case envelopes(IdentifiedActionOf<Envelope>)
  }

  var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      default:
        return .none
      }
    }
    .forEach(\.envelopes, action: \.envelopes) {
      Envelope()
    }
  }
}
