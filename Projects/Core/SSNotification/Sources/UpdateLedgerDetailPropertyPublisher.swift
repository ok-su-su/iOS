//
//  UpdateLedgerDetailPropertyPublisher.swift
//  SSNotification
//
//  Created by MaraMincho on 8/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

@preconcurrency import Combine
import ComposableArchitecture
import Foundation

// MARK: - UpdateLedgerDetailPublisher

public struct UpdateLedgerDetailPublisher: DependencyKey, Sendable {
  public static let liveValue: UpdateLedgerDetailPublisher = .init()
  private init() {}

  private var _updateLedgerDetailPublisher: PassthroughSubject<Void, Never> = .init()
  public var updateLedgerDetailPublisher: AnyPublisher<Void, Never> {
    _updateLedgerDetailPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func updateLedgerDetail() {
    _updateLedgerDetailPublisher.send()
  }

  private var _updateEnvelopesPublisher: PassthroughSubject<Void, Never> = .init()
  public var updateEnvelopesPublisher: AnyPublisher<Void, Never> {
    _updateEnvelopesPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func updateEnvelopes() {
    _updateLedgerDetailPublisher.send()
  }

  private var _updateEnvelopePublisher: PassthroughSubject<Int64, Never> = .init()
  public var updateEnvelopePublisher: AnyPublisher<Int64, Never> {
    _updateEnvelopePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func updateEnvelope(id: Int64) {
    _updateEnvelopePublisher.send(id)
  }

  private var _deleteEnvelopePublisher: PassthroughSubject<Int64, Never> = .init()
  public var deleteEnvelopePublisher: AnyPublisher<Int64, Never> {
    _deleteEnvelopePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func deleteEnvelope(id: Int64) {
    _deleteEnvelopePublisher.send(id)
  }
}

public extension DependencyValues {
  var updateLedgerDetailPublisher: UpdateLedgerDetailPublisher { self[UpdateLedgerDetailPublisher.self] }
}
