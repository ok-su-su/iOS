//
//  CreateLedgerRouterPathPublisher.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

final class CreateLedgerRouterPathPublisher {
  static let shared = CreateLedgerRouterPathPublisher()
  private var _publisher: PassthroughSubject<CreateLedgerRouterPath.State, Never> = .init()

  static func publisher() -> AnyPublisher<CreateLedgerRouterPath.State, Never> {
    shared._publisher.eraseToAnyPublisher()
  }

  static func push(_ val: CreateLedgerRouterPath.State) {
    shared._publisher.send(val)
  }
}
