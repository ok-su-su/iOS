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


public final class ReceivedMainUpdatePublisher {
  private init() {}

  private var _updatePublisher = PassthroughSubject<Void, Never>()
  public var updatePublisher: AnyPublisher<Void, Never> { _updatePublisher.eraseToAnyPublisher() }
  public func sendUpdatePage() {
    _updatePublisher.send()
  }

  private var _deleteLedgerPublisher = PassthroughSubject<Int64, Never>()
  public var deleteLedgerPublisher: AnyPublisher<Int64, Never> { _deleteLedgerPublisher.eraseToAnyPublisher() }
  public func deleteLedger(ledgerID: Int64) {
    _deleteLedgerPublisher.send(ledgerID)
  }

  private var _updateLedgerPublisher = PassthroughSubject<Int64, Never>()
  public var updateLedgerPublisher: AnyPublisher<Int64, Never> { _updateLedgerPublisher.eraseToAnyPublisher() }
  public func editLedger(ledgerID: Int64) {
    _updateLedgerPublisher.send(ledgerID)
  }
}
