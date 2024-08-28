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
  /// Vote Detail을 가져 옵니다.
  var voteDetail: @Sendable (_ id: Int64) async throws -> VoteDetailProperty

  @Sendable
  private static func _voteDetail(_ id: Int64) async throws -> VoteDetailProperty {
    try await provider.request(.getVoteDetail(boardID: id))
  }

  /// 투표를 실행합니다.
  var executeVote: @Sendable (_ boardID: Int64, _ optionID: Int64) async throws -> Void
  @Sendable
  private static func _executeVote(_ boardID: Int64, _ optionID: Int64) async throws {
    try await provider.request(.executeVote(boardID: boardID, optionID: optionID))
  }

  /// 실행한 투표를 취소 합니다.
  var cancelVote: @Sendable (_ boardID: Int64, _ optionID: Int64) async throws -> Void
  @Sendable
  private static func _cancelVote(_ boardID: Int64, _ optionID: Int64) async throws {
    try await provider.request(.cancelVote(boardID: boardID, optionID: optionID))
  }

  /// 투표를 덮어씁니다.
  var overwriteVote: @Sendable (_ boardID: Int64, _ optionID: Int64) async throws -> Void
  @Sendable
  private static func _overwriteVote(_ boardID: Int64, _ optionID: Int64) async throws {
    try await provider.request(.overwriteVote(boardID: boardID, optionID: optionID))
  }

  /// 자신의 투표를 삭제합니다.
  var deleteVote: @Sendable (_ boardID: Int64) async throws -> Void
  @Sendable
  private static func _deleteVote(_ boardID: Int64) async throws {
    try await provider.request(.deleteVote(boardID: boardID))
  }

  /// 투표를 신고합니다.
  var reportVote: @Sendable (_ boardID: Int64) async throws -> Void

  /// 사용자를 차단 합니다.
  var blockUser: @Sendable (_ userID: Int64) async throws -> Void
}

// MARK: - VoteMainNetworkLiveFunction

private enum VoteMainNetworkLiveFunction {
  static var voteMainReportVote: @Sendable (_ boardID: Int64) async throws -> Void = VoteMainNetwork.liveValue.reportVote
  private static var voteMainBlockUser: @Sendable (_ userID: Int64) async throws -> Void = VoteMainNetwork.liveValue.blockUser
}

// MARK: - VoteDetailNetwork + DependencyKey

extension VoteDetailNetwork: DependencyKey {
  
  /// reportVote, blockUser는 VoteMain의 Network API를 활용합니다.
  static var liveValue: VoteDetailNetwork = .init(
    voteDetail: _voteDetail,
    executeVote: _executeVote,
    cancelVote: _cancelVote,
    overwriteVote: _overwriteVote,
    deleteVote: _deleteVote,
    reportVote: VoteMainNetworkLiveFunction.voteMainReportVote,
    blockUser: VoteMainNetworkLiveFunction.voteMainReportVote
  )
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case getVoteDetail(boardID: Int64)
    case executeVote(boardID: Int64, optionID: Int64)
    case overwriteVote(boardID: Int64, optionID: Int64)
    case cancelVote(boardID: Int64, optionID: Int64)
    case deleteVote(boardID: Int64)
    //    case updateVote(postID: Int64)

    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case let .getVoteDetail(boardID):
        "votes/\(boardID)"
      case let .executeVote(boardID, _):
        "votes/\(boardID)"
      case let .overwriteVote(boardID, _):
        "votes/\(boardID)/vote"
      case let .cancelVote(boardID, _):
        "votes/\(boardID)"
      case let .deleteVote(boardID):
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
        .patch
      case .cancelVote:
        .post
      case .deleteVote:
        .delete
      }
    }

    var task: Moya.Task {
      switch self {
      case .getVoteDetail:
        return .requestPlain
      case let .executeVote(_, optionID):
        let data = try? JSONEncoder.default.encode(CreateVoteHistoryRequest(id: optionID))
        return .requestData(data ?? .init())
      case let .overwriteVote(_, optionID):
        let data = try? JSONEncoder.default.encode(OverwriteVoteHistoryRequest(optionId: optionID))
        return .requestData(data ?? .init())
      case let .cancelVote(_, optionID):
        let data = try? JSONEncoder.default.encode(CreateVoteHistoryRequest(isCancel: true, optionId: optionID))
        return .requestData(data ?? .init())
      case let .deleteVote(boardID):
        return .requestPlain
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
  let optionId: Int64
  init(isCancel: Bool, optionId: Int64) {
    self.isCancel = isCancel
    self.optionId = optionId
  }

  init(id: Int64) {
    isCancel = false
    optionId = id
  }

  enum CodingKeys: CodingKey {
    case isCancel
    case optionId
  }
}

// MARK: - UpdateVoteRequest

struct UpdateVoteRequest: Encodable {
  /// 보드 id
  let boardId: Int64
  ///   투표 내용
  let content: String
  enum CodingKeys: CodingKey {
    case boardId
    case content
  }
}

// MARK: - OverwriteVoteHistoryRequest

struct OverwriteVoteHistoryRequest: Encodable {
  let optionId: Int64
  enum CodingKeys: CodingKey {
    case optionId
  }
}
