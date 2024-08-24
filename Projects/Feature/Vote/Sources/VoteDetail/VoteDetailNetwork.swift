//
//  VoteDetailNetwork.swift
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

// MARK: - VoteDetailNetwork

struct VoteDetailNetwork {
  // Vote Detail을 가져 옵니다.
  var voteDetail: (_ id: Int64) async throws -> VoteDetailProperty
  private static func _voteDetail(_ id: Int64) async throws -> VoteDetailProperty {
    try await provider.request(.getVoteDetail(boardID: id))
  }
}

// MARK: DependencyKey

extension VoteDetailNetwork: DependencyKey {
  static var liveValue: VoteDetailNetwork = .init(
    voteDetail: _voteDetail
  )
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case getVoteDetail(boardID: Int64)
    ///    case executeVote(postID: Int64, voteID: Int64)
    ///    case deleteVote(postID: Int64)
    ///    case updateVote(postID: Int64)
    ///    case overwriteVote(boardID: Int64)
    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case let .getVoteDetail(boardID):
        "votes/\(boardID)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getVoteDetail:
        .get
      }
    }

    var task: Moya.Task {
      switch self {
      case .getVoteDetail:
        .requestPlain
      }
    }
  }
}

extension DependencyValues {
  var voteDetailNetwork: VoteDetailNetwork {
    get { self[VoteDetailNetwork.self] }
    set { self[VoteDetailNetwork.self] = newValue }
  }
}

// MARK: - CreateVoteHistoryRequest

struct CreateVoteHistoryRequest: Encodable {
  let isCancel: Bool
  let optionID: Int64
}

// MARK: - UpdateVoteRequest

struct UpdateVoteRequest: Encodable {
  /// 보드 id
  let boardId: Int64
  ///   투표 내용
  let content: String
}

// MARK: - OverwriteVoteHistoryRequest

struct OverwriteVoteHistoryRequest: Encodable {
  let optionId: Int64
}
