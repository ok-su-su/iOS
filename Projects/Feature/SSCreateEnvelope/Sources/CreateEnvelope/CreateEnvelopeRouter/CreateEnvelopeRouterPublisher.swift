//
//  CreateEnvelopeRouterPublisher.swift
//  Sent
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import SSFirebase

// MARK: - CreateEnvelopePath

@CasePathable
@Reducer(state: .equatable, action: .equatable)
public enum CreateEnvelopePath {
  case createEnvelopePrice(CreateEnvelopePrice)
  case createEnvelopeName(CreateEnvelopeName)
  case createEnvelopeRelation(CreateEnvelopeRelation)
  case createEnvelopeEvent(CreateEnvelopeCategory)
  case createEnvelopeDate(CreateEnvelopeDate)
  case createEnvelopeAdditionalSection(CreateEnvelopeAdditionalSection)
  case createEnvelopeAdditionalMemo(CreateEnvelopeAdditionalMemo)
  case createEnvelopeAdditionalContact(CreateEnvelopeAdditionalContact)
  case createEnvelopeAdditionalIsGift(CreateEnvelopeAdditionalIsGift)
  case createEnvelopeAdditionalIsVisitedEvent(CreateEnvelopeAdditionalIsVisitedEvent)
}

// MARK: - CreateEnvelopeRouterPublisher

public final class CreateEnvelopeRouterPublisher {
  public static let shared = CreateEnvelopeRouterPublisher()
  private init() {}

  private var _publisher: PassthroughSubject<CreateEnvelopePath.State, Never> = .init()
  private var _endedPublisher: PassthroughSubject<CreateEnvelopePath.State, Never> = .init()

  public func publisher() -> AnyPublisher<CreateEnvelopePath.State, Never> {
    return _publisher.eraseToAnyPublisher()
  }

  public func endedPublisher() -> AnyPublisher<CreateEnvelopePath.State, Never> {
    return _endedPublisher.eraseToAnyPublisher()
  }

  public func ended(_ val: CreateEnvelopePath.State) {
    _endedPublisher.send(val)
  }

  public func push(_ val: CreateEnvelopePath.State) {
    _publisher.send(val)
  }
}
