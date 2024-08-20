//
//  SentDestination.swift
//  Sent
//
//  Created by MaraMincho on 8/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import SSCreateEnvelope

// MARK: - SentDestination

@Reducer
enum SentDestination {
  case envelopeFilter(SentEnvelopeFilter)
  case createEnvelope(CreateEnvelopePath.Body = CreateEnvelopePath.body)
}

// MARK: - SentPublisher

final class SentPublisher {
  static let shared: SentPublisher = .init()
  private var subscriptions: Set<AnyCancellable> = .init()

  private init() {
    CreateEnvelopeRouterPublisher
      .shared
      .publisher()
      .sink { [weak self] state in
        self?._publisher.send(.createEnvelope(state))
      }
      .store(in: &subscriptions)
  }

  private var _publisher: PassthroughSubject<SentDestination.State, Never> = .init()
  public func publisher() -> AnyPublisher<SentDestination.State, Never> {
    return _publisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func push(_ val: SentDestination.State) {
    _publisher.send(val)
  }
}

let t = SentPublisher.shared.publisher()
