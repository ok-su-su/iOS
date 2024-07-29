//
//  ReceivedMainObserver.swift
//  Received
//
//  Created by MaraMincho on 7/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Dependencies
import Foundation

// MARK: - ReceivedMainObserver

final class ReceivedMainObserver {
  static let shared = ReceivedMainObserver()

  func updateLedgers() {
    updateLedgerPublisher.send()
  }

  let updateLedgerPublisher: PassthroughSubject<Void, Never> = .init()
}

// MARK: DependencyKey

extension ReceivedMainObserver: DependencyKey {
  static var liveValue: ReceivedMainObserver { shared }
}

extension DependencyValues {
  var receivedMainObserver: ReceivedMainObserver {
    get { self[ReceivedMainObserver.self] }
    set { self[ReceivedMainObserver.self] = newValue }
  }
}
