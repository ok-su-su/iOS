//
//  VoteMainNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork
import Dependencies
import Moya
import SSInterceptor

struct VoteMainNetwork {
  var getPopularItems: () async throws -> [PopularVoteItem]
  private static func _getPopularItems() async throws -> [PopularVoteItem] {
    let datum: [VoteWithCountResponse] = try await provider.request(.getPopularItems)
    return datum.map {  .init(
      id: $0.id,
      categoryTitle: $0.board.name,
      content: $0.content,
      isActive: $0.board.isActive,
      isModified: $0.isModified,
      participantCount: $0.count
    )}
  }
}

extension VoteMainNetwork: DependencyKey {
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))
  static var liveValue: VoteMainNetwork = .init(
   getPopularItems: _getPopularItems
  )
  enum Network: SSNetworkTargetType {
    case getPopularItems

    var additionalHeader: [String : String]? { nil}

    var path: String {
      switch self {
      case .getPopularItems:
        "votes/popular"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getPopularItems:
          .get
      }
    }

    var task: Moya.Task {
      switch self {
      case .getPopularItems:
          .requestPlain
      }
    }

  }
}

