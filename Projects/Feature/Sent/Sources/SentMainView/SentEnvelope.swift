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
    public var envelopeProperty: EnvelopeProperty
    public var showDetail: Bool = false

    public var progressValue: CGFloat {
      return 150
    }
  }

  public enum Action: Equatable {
    case tappedDetailButton
    case tappedFullContentOfEnvelopeButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in

      switch action {
      case .tappedDetailButton:
        state.showDetail.toggle()
        return .none
      default:
        return .none
      }
    }
  }
}
