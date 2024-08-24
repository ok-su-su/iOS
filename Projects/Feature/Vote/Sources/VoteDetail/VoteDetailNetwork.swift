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
  var executeVote: (_ boardID: Int64, _ optionID: Int64) async throws -> Void
  private static func _executeVote(_ boardID: Int64, _ optionID: Int64) async throws {
    try await provider.request(.executeVote(boardID: boardID, optionID: optionID))
  }

  var overwriteVote: (_ boardID: Int64, _ optionID: Int64) async throws -> Void
  private static func _overwriteVote(_ boardID: Int64, _ optionID: Int64) async throws -> Void {
    try await provider.request(.executeVote(boardID: boardID, optionID: optionID))
  }
}

// MARK: DependencyKey

extension VoteDetailNetwork: DependencyKey {
  static var liveValue: VoteDetailNetwork = .init(
    voteDetail: _voteDetail,
    executeVote: _executeVote,
    overwriteVote: _overwriteVote
  )
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case getVoteDetail(boardID: Int64)
    case executeVote(boardID: Int64, optionID: Int64)
    case overwriteVote(boardID: Int64, optionID: Int64)
    ///    case deleteVote(postID: Int64)
    ///    case updateVote(postID: Int64)
    

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case let .getVoteDetail(boardID):
        "votes/\(boardID)"
      case let .executeVote(boardID, _):
        "votes/\(boardID)"
      case let .overwriteVote(boardID,_):
        "votes/\(boardID)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getVoteDetail:
        .get
      case .executeVote:
          .post
      case .overwriteVote:
          .post
      }
    }

    var task: Moya.Task {
      switch self {
      case .getVoteDetail:
        return .requestPlain
      case let .executeVote(_, optionID):
        let data = try? JSONEncoder.default.encode(CreateVoteHistoryRequest(id: optionID))
        return   .requestData(data ?? .init())
      case let .overwriteVote(_, optionID):
        let data = try? JSONEncoder.default.encode(OverwriteVoteHistoryRequest(optionId: optionID))
        return .requestData(data ?? .init())
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
  init(isCancel: Bool, optionID: Int64) {
    self.isCancel = isCancel
    self.optionID = optionID
  }
  init(id: Int64) {
    isCancel = false
    self.optionID = id
  }
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
