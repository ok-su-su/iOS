//
//  SpecificEnvelopePublisher.swift
//  SSNotification
//
//  Created by MaraMincho on 8/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

// MARK: - SpecificEnvelopePublisher

public final class SpecificEnvelopePublisher: @unchecked Sendable {
  private init() {}

  private let _updatePublisher: PassthroughSubject<Int64, Never> = .init()
  public var updateEnvelopeIDPublisher: AnyPublisher<Int64, Never> {
    _updatePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func sendUpdateEnvelopeBy(ID: Int64) {
    _updatePublisher.send(ID)
  }

  private var _deleteEnvelopePublisher: PassthroughSubject<Int64, Never> = .init()
  public var deleteEnvelopePublisher: AnyPublisher<Int64, Never> {
    _deleteEnvelopePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func sendDeleteEnvelopeBy(ID: Int64) {
    _deleteEnvelopePublisher.send(ID)
  }
}

// MARK: DependencyKey

extension SpecificEnvelopePublisher: DependencyKey {
  public static let liveValue: SpecificEnvelopePublisher = .init()
}

public extension DependencyValues {
  var specificEnvelopePublisher: SpecificEnvelopePublisher { self[SpecificEnvelopePublisher.self] }
}
