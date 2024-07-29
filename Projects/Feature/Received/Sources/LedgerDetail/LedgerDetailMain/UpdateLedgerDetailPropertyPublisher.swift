//
//  UpdateLedgerDetailPropertyPublisher.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Dependencies
import Foundation

// MARK: - UpdateLedgerDetailPropertyPublisher

struct UpdateLedgerDetailPropertyPublisher: DependencyKey {
  static var liveValue: UpdateLedgerDetailPropertyPublisher = .init()
  private init() {}
  private let _publisher: PassthroughSubject<Int64, Never> = .init()

  public func send(ledgerID: Int64) {
    _publisher.send(ledgerID)
  }

  public func publisher() -> AnyPublisher<Int64, Never> {
    _publisher.eraseToAnyPublisher()
  }
}

extension DependencyValues {
  var updateLedgerDetailPropertyPublisher: UpdateLedgerDetailPropertyPublisher {
    get { self[UpdateLedgerDetailPropertyPublisher.self] }
    set { self[UpdateLedgerDetailPropertyPublisher.self] = newValue }
  }
}
