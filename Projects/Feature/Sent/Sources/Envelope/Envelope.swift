//
//  Envelope.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSFirebase

@Reducer
struct Envelope: Sendable {
  @ObservableState
  struct State: Identifiable, Sendable {
    var id: Int64 { envelopeProperty.id }
    var envelopeProperty: EnvelopeProperty
    var showDetail: Bool = false
    var envelopePriceProgressProperty: EnvelopePriceProgressProperty { .init(
      leadingPriceValue: envelopeProperty.totalSentPrice,
      trailingPriceValue: envelopeProperty.totalReceivedPrice
    ) }

    var isLoading: Bool = false
    var isAppear: Bool = false

    var progressValue: CGFloat {
      return 150
    }

    init(envelopeProperty: EnvelopeProperty) {
      self.envelopeProperty = envelopeProperty
    }
  }

  @Dependency(\.envelopeNetwork) var network

  enum Action: Equatable, Sendable {
    case tappedDetailButton
    case tappedFullContentOfEnvelopeButton
    case getEnvelopeDetail
    case isLoading(Bool)
    case updateEnvelopeContent([EnvelopeContent])
    case pushEnvelopeDetail(EnvelopeProperty)
    case isOnAppear(Bool)
  }

  var body: some Reducer<State, Action> {
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

      case .getEnvelopeDetail:
        ssLogEvent(.MyPage(.main), eventName: "인물 봉투 전체보기 버튼", eventType: .tapped)
        return .ssRun { [id = state.envelopeProperty.id] send in
          await send(.isLoading(true))
          let value = try await network.getEnvelope(.init(friendID: id, page: 0))
          let threeEnvelopes = Array(value.prefix(3))
          await send(.updateEnvelopeContent(threeEnvelopes))
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
