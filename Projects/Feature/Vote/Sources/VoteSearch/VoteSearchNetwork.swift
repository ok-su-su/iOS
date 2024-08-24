//
//  VoteSearchNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Dependencies
import Moya
import SSNetwork
import SSInterceptor

struct VoteSearchNetwork {
  var searchByVoteName: @Sendable (_ text: String) async throws -> [VoteSearchItem]
  @Sendable static func _searchByVoteName(_ name: String) async throws -> [VoteSearchItem] {
    let response: SliceResponseDtoVoteAndOptionsWithCountResponse = try await provider.request(.searchByVoteName(name))
    return response.data.map{$0.convertToVoteSearchItem()}
  }
}

extension VoteSearchNetwork: DependencyKey {
  static var liveValue: VoteSearchNetwork = .init(searchByVoteName: _searchByVoteName)
  static var provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case searchByVoteName(String)

    var additionalHeader: [String : String]? { nil }
    var path: String { "votes"}
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

fileprivate extension VoteAndOptionsWithCountResponse {
  func convertToVoteSearchItem() -> VoteSearchItem {
    .init(id: id, title: content, firstContentDescription: nil, secondContentDescription: nil)
  }
}
