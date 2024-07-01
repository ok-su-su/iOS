//
//  ReceivedMainRefreshPublisher.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine

final class ReceivedMainRefreshPublisher {
  let _publisher = PassthroughSubject<Void, Never>()

  private static let shared = ReceivedMainRefreshPublisher()

  static func publisher() -> AnyPublisher<Void, Never> {
    shared._publisher.eraseToAnyPublisher()
  }

  static func refresh() {
    shared._publisher.send()
  }
}
