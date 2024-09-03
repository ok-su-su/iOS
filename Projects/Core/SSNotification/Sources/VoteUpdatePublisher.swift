//
//  VoteUpdatePublisher.swift
//  SSNotification
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

// MARK: - VoteUpdatePublisher

public final class VoteUpdatePublisher: DependencyKey {
  public static var liveValue: VoteUpdatePublisher = .init()
  private init() {}

  private var _updateVoteListPublisher: PassthroughSubject<Void, Never> = .init()
  public var updateVoteListPublisher: AnyPublisher<Void, Never> {
    _updateVoteListPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func updateVoteList() {
    _updateVoteListPublisher.send()
  }

  private var _deleteVotePublisher: PassthroughSubject<Int64, Never> = .init()
  public var deleteVotePublisher: AnyPublisher<Int64, Never> {
    _deleteVotePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func deleteVote(ID: Int64) {
    _deleteVotePublisher.send(ID)
  }

  private var _createdVotePublisher: PassthroughSubject<Int64, Never> = .init()
  public var createdVotePublisher: AnyPublisher<Int64, Never> {
    _createdVotePublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func createdVote(ID id: Int64) {
    _createdVotePublisher.send(id)
  }

  private var _reflectVoteCountPublisher: PassthroughSubject<(ID: Int64, Count: Int64), Never> = .init()
  public var reflectVoteCountPublisher: AnyPublisher<(ID: Int64, Count: Int64), Never> {
    _reflectVoteCountPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  public func updateVoteCount(voteID: Int64, count: Int64) {
    _reflectVoteCountPublisher.send((voteID, count))
  }
}

public extension DependencyValues {
  var voteUpdatePublisher: VoteUpdatePublisher { self[VoteUpdatePublisher.self] }
}
