//
//  SpecificEnvelopeHistoryRouterPunlisher.swift
//  Sent
//
//  Created by MaraMincho on 6/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

final class SpecificEnvelopeHistoryRouterPublisher {
  private static var _publisher: PassthroughSubject<SpecificEnvelopeHistoryRouterPath.State, Never> = .init()
  private init() {}
  static var publisher: AnyPublisher<SpecificEnvelopeHistoryRouterPath.State, Never> { _publisher.eraseToAnyPublisher() }
  static func push(_ val: SpecificEnvelopeHistoryRouterPath.State) {
    _publisher.send(val)
  }
}
