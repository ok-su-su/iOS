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
    var id: UUID = .init()
    var envelopeProperty: EnvelopeProperty
    var showDetail: Bool = false
    var envelopePriceProgress: EnvelopePriceProgress.State = .init(envelopePriceProgressProperty: .makeFakeData())
    var isLoading: Bool = false
    var isAppear: Bool = false

    var progressValue: CGFloat {
      return 150
    }

    init(envelopeProperty: EnvelopeProperty) {
      self.envelopeProperty = envelopeProperty
      envelopePriceProgress = .init(
        envelopePriceProgressProperty:
        .init(
          leadingPriceValue: envelopeProperty.totalSentPrice,
          trailingPriceValue: envelopeProperty.totalReceivedPrice
        )
      )
    }
  }

  @Dependency(\.envelopeNetwork) var network

  enum Action: Equatable {
    case tappedDetailButton
    case tappedFullContentOfEnvelopeButton
    case envelopePRiceProgress(EnvelopePriceProgress.Action)
    case getEnvelopeDetail
    case isLoading(Bool)
    case updateEnvelopeContent([EnvelopeContent])
    case pushEnvelopeDetail(EnvelopeProperty)
    case isOnAppear(Bool)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.envelopePriceProgress, action: \.envelopePRiceProgress) {
      EnvelopePriceProgress()
    }
    Reduce { state, action in
      switch action {
      case .tappedDetailButton:
        state.showDetail.toggle()
        if state.showDetail && state.envelopeProperty.envelopeContents.isEmpty {
          return .send(.getEnvelopeDetail)
        }
        return .none

      case .tappedFullContentOfEnvelopeButton:
        return .send(.pushEnvelopeDetail(state.envelopeProperty))

      case .envelopePRiceProgress:
        return .none
      case .getEnvelopeDetail:
        return .run { [id = state.envelopeProperty.id] send in
          await send(.isLoading(true))
          let value = try await network.getEnvelope(id: id)
          await send(.updateEnvelopeContent(value))
          await send(.isLoading(false))
        }
      case let .isLoading(val):
        state.isLoading = val
        return .none
      case let .updateEnvelopeContent(val):
        state.envelopeProperty.envelopeContents = val
        return .none
      case .pushEnvelopeDetail:
        return .none
      case let .isOnAppear(appeared):
        if state.isAppear {
          return .none
        }
        state.isAppear = appeared
        return .none
      }
    }
  }
}
