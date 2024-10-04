//
//  UpdateEnvelopeDetailPropertyPublisher.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

public final class UpdateEnvelopeDetailPropertyPublisher {
  private init() {}
  private var _publisher: PassthroughSubject<EnvelopeDetailProperty, Never> = .init()

  private nonisolated(unsafe) static let shared = UpdateEnvelopeDetailPropertyPublisher()

  public static func send(_ property: EnvelopeDetailProperty) {
    shared._publisher.send(property)
  }

  public static func publisher() -> AnyPublisher<EnvelopeDetailProperty, Never> {
    shared._publisher.eraseToAnyPublisher()
  }
}
