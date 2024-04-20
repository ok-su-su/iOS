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
public struct SentMain {
  public init() {}
  @ObservableState
  public struct State {
    var envelopes: IdentifiedArrayOf<Envelope.State> = []
    public init() {}
  }

  public enum Action: Equatable {
    case tappedFirstButton
    case filterButtonTapped
    case tappedEmptyEnvelopeButton
    case envelopes(IdentifiedActionOf<Envelope>)
  }

  public var body: some Reducer<State, Action> {
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
