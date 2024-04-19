//
//  SentEnvelope.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Envelope {
  @ObservableState
  public struct State: Identifiable {
    public var id = UUID()
    public var envelopeProperty: Envelope
  }

  public struct Action: Equatable {}

  public var body: some Reducer<State, Action> {
    Reduce { _, action in

      switch action {
      default:
        return .none
      }
    }
  }
}
