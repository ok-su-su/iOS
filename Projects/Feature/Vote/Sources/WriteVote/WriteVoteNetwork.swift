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

// MARK: - WriteVoteNetwork

struct WriteVoteNetwork {
  var createVote: @Sendable (CreateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse
  @Sendable
  private static func _createVote(_ createVoteRequestBody: CreateVoteRequestBody) async throws -> CreateAndUpdateVoteResponse {
    let data = try JSONEncoder.default.encode(createVoteRequestBody)
    return try await provider.request(.createVote(CreateVoteRequestBodyToData: data))
  }
}

// MARK: DependencyKey

extension WriteVoteNetwork: DependencyKey {
  static var liveValue: WriteVoteNetwork = .init(createVote: _createVote)

  static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  enum Network: SSNetworkTargetType {
    case createVote(CreateVoteRequestBodyToData: Data)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .createVote:
        "votes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .createVote:
        .post
      }
    }

    var task: Moya.Task {
      switch self {
      case let .createVote(CreateVoteRequestBodyToData):
        .requestData(CreateVoteRequestBodyToData)
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
