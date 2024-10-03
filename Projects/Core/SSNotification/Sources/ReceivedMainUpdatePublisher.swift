//
//  ReceivedMainUpdatePublisher.swift
//  SSNotification
//
//  Created by MaraMincho on 8/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

// MARK: - ReceivedMainUpdatePublisher

public final class ReceivedMainUpdatePublisher: @unchecked Sendable {
  private init() {}

  private var _updatePublisher = PassthroughSubject<Void, Never>()
  public var updatePublisher: AnyPublisher<Void, Never> {
    _updatePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func sendUpdatePage() {
    _updatePublisher.send()
  }

  private var _deleteLedgerPublisher = PassthroughSubject<Int64, Never>()
  public var deleteLedgerPublisher: AnyPublisher<Int64, Never> {
    _deleteLedgerPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func deleteLedger(ledgerID: Int64) {
    _deleteLedgerPublisher.send(ledgerID)
  }

  private var _updateLedgerPublisher = PassthroughSubject<Int64, Never>()
  public var updateLedgerPublisher: AnyPublisher<Int64, Never> {
    _updateLedgerPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func editLedger(ledgerID: Int64) {
    _updateLedgerPublisher.send(ledgerID)
  }
}

// MARK: DependencyKey

extension ReceivedMainUpdatePublisher: DependencyKey {
  public static var liveValue: ReceivedMainUpdatePublisher {
    .init()
  }
}

public extension DependencyValues {
  var receivedMainUpdatePublisher: ReceivedMainUpdatePublisher {
    self[ReceivedMainUpdatePublisher.self]
  }
}
