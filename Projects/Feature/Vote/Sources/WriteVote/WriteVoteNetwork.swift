//
//  WriteVoteNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

typealias CreateVoteRequestBody = CreateVoteRequest
typealias UpdateVoteRequestBody = UpdateVoteRequest

// MARK: - WriteVoteNetwork

struct WriteVoteNetwork: Sendable {
  var createVote: @Sendable (CreateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse
  @Sendable
  private static func _createVote(_ createVoteRequestBody: CreateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse {
    let data = try JSONEncoder.default.encode(createVoteRequestBody)
    return try await provider.request(.createVote(CreateVoteRequestBodyToData: data))
  }

  var updateVote: @Sendable (_ id: Int64, _ updateVoteRequestBody: UpdateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse
  @Sendable
  private static func _updateVote(_ id: Int64, _ updateVoteRequestBody: UpdateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse {
    let data = try JSONEncoder.default.encode(updateVoteRequestBody)
    return try await provider.request(.updateVote(
      id: id,
      UpdateVoteRequestBodyToData: data
    ))
  }
}

// MARK: DependencyKey

extension WriteVoteNetwork: DependencyKey {
  static let liveValue: WriteVoteNetwork = .init(
    createVote: _createVote,
    updateVote: _updateVote
  )

  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  enum Network: SSNetworkTargetType {
    case createVote(CreateVoteRequestBodyToData: Data)
    case updateVote(id: Int64, UpdateVoteRequestBodyToData: Data)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .createVote:
        "votes"
      case let .updateVote(id, _):
        "votes/\(id)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .createVote:
        .post
      case .updateVote:
        .patch
      }
    }

    var task: Moya.Task {
      switch self {
      case let .createVote(CreateVoteRequestBodyToData):
        .requestData(CreateVoteRequestBodyToData)
      case let .updateVote(_, updateVoteRequestBodyToData):
        .requestData(updateVoteRequestBodyToData)
      }
    }
  }
}

extension DependencyValues {
  var writeVoteNetwork: WriteVoteNetwork {
    get { self[WriteVoteNetwork.self] }
    set { self[WriteVoteNetwork.self] = newValue }
  }
}
