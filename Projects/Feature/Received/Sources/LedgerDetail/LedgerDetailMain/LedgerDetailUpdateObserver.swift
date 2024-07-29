//
//  LedgerDetailUpdateObserver.swift
//  Received
//
//  Created by MaraMincho on 7/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Dependencies
import Foundation

// MARK: - LedgerDetailUpdateObserver

final class LedgerDetailUpdateObserver {
  func updateLedgerDetail() {
    updateLedgerDetailPublisher.send()
  }

  func updateEnvelopes() {
    updateEnvelopesPublisher.send()
  }

  func updateAllProperty() {
    updateLedgerDetailPublisher.send()
    updateEnvelopesPublisher.send()
  }

  var updateLedgerDetailPublisher: PassthroughSubject<Void, Never> = .init()

  var updateEnvelopesPublisher: PassthroughSubject<Void, Never> = .init()

  private init() {}

  private static let shared = LedgerDetailUpdateObserver()
}

// MARK: DependencyKey

extension LedgerDetailUpdateObserver: DependencyKey {
  static var liveValue: LedgerDetailUpdateObserver { .shared }
}

extension DependencyValues {
  var ledgerDetailObserver: LedgerDetailUpdateObserver { self[LedgerDetailUpdateObserver.self] }
}
