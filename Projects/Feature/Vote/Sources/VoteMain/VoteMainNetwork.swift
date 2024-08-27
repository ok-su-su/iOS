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
  var getPopularItems: @Sendable () async throws -> [PopularVoteItem]
  @Sendable
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

  var getVoteItems: @Sendable (_ param: GetVoteRequestQueryParameter?) async throws -> VoteNetworkResponse
  var getInitialVoteItems: @Sendable () async throws -> VoteNetworkResponse
  @Sendable
  private static func _getVoteItems(_ param: GetVoteRequestQueryParameter?) async throws -> VoteNetworkResponse {
    let param = param ?? .init()
    let response: SliceResponseDtoVoteAndOptionsWithCountResponse = try await provider.request(.getVoteItems(param))
    return .init(
      items: response.data.map { $0.convertVotePreviewProperty() },
      page: response.page,
      size: response.size,
      hasNext: response.hasNext
    )
  }

  var getVoteCategory: @Sendable () async throws -> [VoteSectionHeaderItem]
  @Sendable
  private static func _getVoteCategory() async throws -> [VoteSectionHeaderItem] {
    let models: [BoardModel] = try await provider.request(.getVoteConfig)
    return models.sorted { $0.seq < $1.seq }.map { $0.convertVoteSectionHeaderItem() }
  }

  var reportVote: @Sendable (_ boardID: Int64) async throws -> Void
  @Sendable
  private static func _reportVote(_ boardID: Int64) async throws -> Void {
    let property = ReportCreateRequest(metadataId: 1, targetId: boardID, targetType: .post)
    let data = try JSONEncoder.default.encode(property)
    try await provider.request(.reportVote(ReportCreateRequestData: data))
  }

  var blockUser: @Sendable (_ userID: Int64) async throws -> Void
  @Sendable
  private static func _blockUser(_ userID: Int64) async throws -> Void {
    let property = CreateBlockRequest(targetId: userID, targetType: .user)
    let data = try JSONEncoder.default.encode(property)
    try await provider.request(.blockUser(CreateBlockRequestData: data))
  }
}

// MARK: DependencyKey

extension VoteMainNetwork: DependencyKey {
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))
  static var liveValue: VoteMainNetwork = .init(
    getPopularItems: _getPopularItems,
    getVoteItems: _getVoteItems,
    getInitialVoteItems: { try await _getVoteItems(nil) },
    getVoteCategory: _getVoteCategory,
    reportVote: _reportVote,
    blockUser: _blockUser
  )
  enum Network: SSNetworkTargetType {
    case getPopularItems
    case getVoteItems(GetVoteRequestQueryParameter)
    case getVoteConfig
    case reportVote(ReportCreateRequestData: Data)
    case blockUser(CreateBlockRequestData: Data)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getPopularItems:
        "votes/popular"
      case .getVoteItems:
        "votes"
      case .getVoteConfig:
        "posts/configs/create-post"
      case .reportVote:
        "reports"
      case .blockUser:
        "blocks"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getPopularItems:
        .get
      case .getVoteItems:
        .get
      case .getVoteConfig:
        .get
      case .reportVote:
          .post
      case .blockUser:
          .post
      }
    }

    var task: Moya.Task {
      switch self {
      case .getPopularItems:
          .requestPlain
      case let .getVoteItems(item):
          .requestParameters(parameters: item.queryParameters, encoding: URLEncoding.queryString)
      case .getVoteConfig:
          .requestPlain
      case let .reportVote(ReportCreateRequestData: data):
          .requestData(data)
      case let .blockUser(CreateBlockRequestData: data):
          .requestData(data)
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
    return .init(categoryTitle: board.name, content: content, id: id, createdAt: createdAt, voteItemsTitle: voteItemsTitle, participateCount: count)
  }
}
