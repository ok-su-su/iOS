//
//  LedgerDetailRouterPublisher.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

final class LedgerDetailRouterPublisher {
  private static let shared = LedgerDetailRouterPublisher()

  private var _publisher = PassthroughSubject<LedgerDetailPath.State, Never>()

  static func publisher() -> AnyPublisher<LedgerDetailPath.State, Never> {
    return shared._publisher.eraseToAnyPublisher()
  }

  static func send(_ state: LedgerDetailPath.State) {
    shared._publisher.send(state)
  }
}
