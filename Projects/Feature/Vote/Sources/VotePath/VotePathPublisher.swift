//
//  VotePathPublisher.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

// MARK: - VotePathPublisher

final class VotePathPublisher {
  nonisolated(unsafe) static var shared: VotePathPublisher = .init()
  private var publisher: PassthroughSubject<VotePathDestination.State, Never> = .init()
  func pathPublisher() -> AnyPublisher<VotePathDestination.State, Never> {
    return publisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  func push(_ path: VotePathDestination.State) {
    publisher.send(path)
  }

  private var _pathPopPublisher: PassthroughSubject<Void, Never> = .init()
  func pathPopPublisher() -> AnyPublisher<Void, Never> {
    _pathPopPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  func pop() {
    _pathPopPublisher.send()
  }

  private init() {}
}
