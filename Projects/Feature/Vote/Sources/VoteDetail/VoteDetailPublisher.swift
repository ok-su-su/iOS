//
//  VoteDetailPublisher.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

// MARK: - VoteDetailPublisher

final class VoteDetailPublisher {
  private static let shared: VoteDetailPublisher = .init()
  private init() {}

  private var _disappearPublisher: PassthroughSubject<VoteDetailDeferNetworkRequest, Never> = .init()
  static var disappearPublisher: AnyPublisher<VoteDetailDeferNetworkRequest, Never> {
    shared._disappearPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  static func disappear(_ property: VoteDetailDeferNetworkRequest) {
    shared._disappearPublisher.send(property)
  }
}

// MARK: - VoteDetailDeferNetworkRequest

struct VoteDetailDeferNetworkRequest: Equatable {
  var boardID: Int64
  var type: VoteDetailDeferNetworkType

  init(boardID: Int64, type: VoteDetailDeferNetworkType) {
    self.boardID = boardID
    self.type = type
  }
}

// MARK: - VoteDetailDeferNetworkType

enum VoteDetailDeferNetworkType: Equatable {
  case just(optionID: Int64)
  case overwrite(optionID: Int64)
  case cancel(optionID: Int64)
  case none
}
