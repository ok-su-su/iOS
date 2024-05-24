//
//  VotePathPublisher.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

// MARK: - VoteRouterBuilder

final class VoteRouterBuilder {
  var voteRouter: VoteRouter = .init()
}

// MARK: - VotePathPublisher

final class VotePathPublisher {
  static var shared: VotePathPublisher = .init()
  private var publisher: PassthroughSubject<VoteRouterPath.State, Never> = .init()
  func pathPublisher() -> AnyPublisher<VoteRouterPath.State, Never> {
    return publisher.eraseToAnyPublisher()
  }

  func push(_ path: VoteRouterPath.State) {
    publisher.send(path)
  }

  private init() {}
}
