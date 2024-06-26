//
//  SentSearchNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - SentSearchNetwork

struct SentSearchNetwork {
  @Dependency(\.createEnvelopeNameNetwork) var searchFriendsNetwork
  @Dependency(\.sentMainNetwork) var searchAmountEnvelopeNetwork

  func searchFriendsBy(name: String) async throws -> [SentSearchItem] {
    return try await searchFriendsNetwork.searchFriendBy(name: name)
  }

  func searchEnvelopeBy(amount: Int) async throws -> [SentSearchItem] {
    return try await searchAmountEnvelopeNetwork.requestSearchFriends(amount)
  }
}

// MARK: DependencyKey

extension SentSearchNetwork: DependencyKey {
  static var liveValue: SentSearchNetwork = .init()
}

extension DependencyValues {
  var sentSearchNetwork: SentSearchNetwork {
    get { self[SentSearchNetwork.self] }
    set { self[SentSearchNetwork.self] = newValue }
  }
}
