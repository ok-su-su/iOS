//
//  VoteSearchNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - VoteSearchNetwork

struct VoteSearchNetwork: Sendable {
  var searchByVoteName: @Sendable (_ text: String) async throws -> [VoteSearchItem]
  @Sendable static func _searchByVoteName(_ name: String) async throws -> [VoteSearchItem] {
    let response: SliceResponseDtoVoteAndOptionsWithCountResponse = try await provider.request(.searchByVoteName(name))
    return response.data.map { $0.convertToVoteSearchItem() }
  }
}

// MARK: DependencyKey

extension VoteSearchNetwork: DependencyKey {
  static let liveValue: VoteSearchNetwork = .init(searchByVoteName: _searchByVoteName)
  nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case searchByVoteName(String)

    var additionalHeader: [String: String]? { nil }
    var path: String { "votes" }
    var method: Moya.Method {
      switch self {
      case .searchByVoteName:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .searchByVoteName(name):
        .requestParameters(parameters: ["content": name], encoding: URLEncoding.queryString)
      }
    }
  }
}

extension DependencyValues {
  var voteSearchNetwork: VoteSearchNetwork {
    get { self[VoteSearchNetwork.self] }
    set { self[VoteSearchNetwork.self] = newValue }
  }
}

private extension VoteAndOptionsWithCountResponse {
  func convertToVoteSearchItem() -> VoteSearchItem {
    .init(id: id, title: content, firstContentDescription: nil, secondContentDescription: nil)
  }
}
