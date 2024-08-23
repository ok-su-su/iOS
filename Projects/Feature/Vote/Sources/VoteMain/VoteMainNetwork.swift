//
//  VoteMainNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - VoteMainNetwork

struct VoteMainNetwork {
  var getPopularItems: () async throws -> [PopularVoteItem]
  private static func _getPopularItems() async throws -> [PopularVoteItem] {
    let datum: [VoteWithCountResponse] = try await provider.request(.getPopularItems)
    return datum.map { .init(
      id: $0.id,
      categoryTitle: $0.board.name,
      content: $0.content,
      isActive: $0.board.isActive,
      isModified: $0.isModified,
      participantCount: $0.count
    ) }
  }

  var getVoteItems: (_ param: GetVoteRequestQueryParameter?) async throws -> GetVoteResponse
  var getInitialVoteItems: () async throws -> GetVoteResponse
  private static func _getVoteItems(_ param: GetVoteRequestQueryParameter?) async throws -> GetVoteResponse {
    let param = param ?? .init()
    let response: SliceResponseDtoVoteAndOptionsWithCountResponse = try await provider.request(.getVoteItems(param))
    return .init(
      items: response.data.map { $0.convertVotePreviewProperty() },
      page: response.page,
      size: response.size,
      hasNext: response.hasNext
    )
  }
}

// MARK: DependencyKey

extension VoteMainNetwork: DependencyKey {
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))
  static var liveValue: VoteMainNetwork = .init(
    getPopularItems: _getPopularItems,
    getVoteItems: _getVoteItems,
    getInitialVoteItems: { try await _getVoteItems(nil) }
  )
  enum Network: SSNetworkTargetType {
    case getPopularItems
    case getVoteItems(GetVoteRequestQueryParameter)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getPopularItems:
        "votes/popular"
      case .getVoteItems:
        "votes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getPopularItems:
        .get
      case .getVoteItems:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case .getPopularItems:
        .requestPlain
      case let .getVoteItems(item):
        .requestParameters(parameters: item.queryParameters, encoding: URLEncoding.queryString)
      }
    }
  }
}

extension DependencyValues {
  var voteMainNetwork: VoteMainNetwork {
    get { self[VoteMainNetwork.self] }
    set { self[VoteMainNetwork.self] = newValue }
  }
}

private extension VoteAndOptionsWithCountResponse {
  func convertVotePreviewProperty() -> VotePreviewProperty {
    let voteItemsTitle = options.sorted(by: { $0.seq < $1.seq }).map(\.content)
    return .init(categoryTitle: board.name, content: content, id: id, createdAt: createdAt, voteItemsTitle: voteItemsTitle)
  }
}
