//
//  Envelope.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Envelope {
  @ObservableState
  struct State: Identifiable {
    var id = UUID()
    var envelopeProperty: EnvelopeProperty
    var showDetail: Bool = false
    var envelopePriceProgress: EnvelopePriceProgress.State = .init(envelopePriceProgressProperty: .makeFakeData())

    var progressValue: CGFloat {
      return 150
    }
  }

  enum Action: Equatable {
    case tappedDetailButton
    case tappedFullContentOfEnvelopeButton
    case envelopePRiceProgress(EnvelopePriceProgress.Action)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.envelopePriceProgress, action: \.envelopePRiceProgress) {
      EnvelopePriceProgress()
    }
    Reduce { state, action in
      switch action {
      case .tappedDetailButton:
        state.showDetail.toggle()
        return .none
      case .tappedFullContentOfEnvelopeButton:
        return .none
      case .envelopePRiceProgress:
        return .none
      }
    }
  }
}
