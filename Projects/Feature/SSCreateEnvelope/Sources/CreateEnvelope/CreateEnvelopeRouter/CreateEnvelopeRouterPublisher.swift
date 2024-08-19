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

// MARK: - PathDestination

@CasePathable
@Reducer(state: .equatable, action: .equatable)
enum PathDestination {
  case createEnvelopePrice(CreateEnvelopePrice)
  case createEnvelopeName(CreateEnvelopeName)
  case createEnvelopeRelation(CreateEnvelopeRelation)
  case createEnvelopeEvent(CreateEnvelopeEvent)
  case createEnvelopeDate(CreateEnvelopeDate)
  case createEnvelopeAdditionalSection(CreateEnvelopeAdditionalSection)
  case createEnvelopeAdditionalMemo(CreateEnvelopeAdditionalMemo)
  case createEnvelopeAdditionalContact(CreateEnvelopeAdditionalContact)
  case createEnvelopeAdditionalIsGift(CreateEnvelopeAdditionalIsGift)
  case createEnvelopeAdditionalIsVisitedEvent(CreateEnvelopeAdditionalIsVisitedEvent)
}

// MARK: - CreateEnvelopePath

@CasePathable
@Reducer(state: .equatable, action: .equatable)
public enum CreateEnvelopePath {
  case createEnvelopePrice(CreateEnvelopePrice)
  case createEnvelopeName(CreateEnvelopeName)
  case createEnvelopeRelation(CreateEnvelopeRelation)
//  case createEnvelopeEvent(CreateEnvelopeEvent)
//  case createEnvelopeDate(CreateEnvelopeDate)
//  case createEnvelopeAdditionalSection(CreateEnvelopeAdditionalSection)
//  case createEnvelopeAdditionalMemo(CreateEnvelopeAdditionalMemo)
//  case createEnvelopeAdditionalContact(CreateEnvelopeAdditionalContact)
//  case createEnvelopeAdditionalIsGift(CreateEnvelopeAdditionalIsGift)
//  case createEnvelopeAdditionalIsVisitedEvent(CreateEnvelopeAdditionalIsVisitedEvent)
}

// MARK: - CreateEnvelopeRouterPublisher

final class CreateEnvelopeRouterPublisher {
  static let shared = CreateEnvelopeRouterPublisher()
  private init() {}

  private var _publisher: PassthroughSubject<PathDestination.State, Never> = .init()
  private var _endedPublisher: PassthroughSubject<PathDestination.State, Never> = .init()

  func publisher() -> AnyPublisher<PathDestination.State, Never> {
    return _publisher.eraseToAnyPublisher()
  }

  func endedPublisher() -> AnyPublisher<PathDestination.State, Never> {
    return _endedPublisher.eraseToAnyPublisher()
  }

  func ended(_ val: PathDestination.State) {
    _endedPublisher.send(val)
  }

  func push(_ val: PathDestination.State) {
    _publisher.send(val)
  }
}
