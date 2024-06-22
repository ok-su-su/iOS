//
//  CreateEnvelopeNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSNetwork

// MARK: - CreateEnvelopeNetwork

struct CreateEnvelopeNetwork {}

// MARK: CreateEnvelopeNetwork.Network

extension CreateEnvelopeNetwork {
  enum Network: SSNetworkTargetType {
    case createFriend(CreateFriendRequestBody)
    case findFriend(name: String)
    case createEnvelope(CreateEnvelopeRequestBody)

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .createFriend,
           .findFriend:
        "friends"
      case .createEnvelope:
        "evenlopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .createEnvelope,
           .createFriend:
        return .post
      case .findFriend:
        return .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .createFriend(bodyProperty):
        return .requestPlain
      case let .findFriend(name):
        return .requestPlain
      case let .createEnvelope(bodyProperty):
        return .requestPlain
      }
    }
  }
}
