//
//  SentUpdatePublisher.swift
//  SSNotification
//
//  Created by MaraMincho on 8/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

// MARK: - SentUpdatePublisher

public final class SentUpdatePublisher: @unchecked Sendable {
  private init() {}

  private var _updatePublisher = PassthroughSubject<Void, Never>()
  public var updatePublisher: AnyPublisher<Void, Never> { _updatePublisher.eraseToAnyPublisher() }
  public func sendUpdatePage() {
    _updatePublisher.send()
  }

  private var _deleteFriendPublisher = PassthroughSubject<Int64, Never>()
  public var deleteFriendPublisher: AnyPublisher<Int64, Never> { _deleteFriendPublisher.eraseToAnyPublisher() }
  public func deleteEnvelopes(friendID: Int64) {
    _deleteFriendPublisher.send(friendID)
  }

  private var _editedFriendPublisher = PassthroughSubject<Int64, Never>()
  public var editedFriendPublisher: AnyPublisher<Int64, Never> { _editedFriendPublisher.eraseToAnyPublisher() }
  public func editEnvelopes(friendID: Int64) {
    _editedFriendPublisher.send(friendID)
  }
}

// MARK: DependencyKey

extension SentUpdatePublisher: DependencyKey {
  public static let liveValue: SentUpdatePublisher = .init()
}

public extension DependencyValues {
  var sentUpdatePublisher: SentUpdatePublisher { self[SentUpdatePublisher.self] }
}
