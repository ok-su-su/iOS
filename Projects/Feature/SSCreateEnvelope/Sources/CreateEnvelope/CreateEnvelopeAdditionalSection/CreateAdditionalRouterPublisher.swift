//
//  CreateAdditionalRouterPublisher.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

// MARK: - CreateAdditionalRouterPublisher

final class CreateAdditionalRouterPublisher {
  private init() {}
  nonisolated(unsafe) static let shared = CreateAdditionalRouterPublisher()

  let _publisher: PassthroughSubject<AdditionalScreen, Never> = .init()

  func publisher() -> AnyPublisher<AdditionalScreen, Never> {
    _publisher.eraseToAnyPublisher()
  }

  func push(from screen: AdditionalScreen) {
    _publisher.send(screen)
  }
}

// MARK: - AdditionalScreen

enum AdditionalScreen: Sendable {
  case selectSection
  case contact
  case gift
  case isVisitedEvent
  case memo
}
