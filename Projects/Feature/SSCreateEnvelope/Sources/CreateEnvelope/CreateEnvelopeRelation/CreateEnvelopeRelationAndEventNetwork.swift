//
//  CreateEnvelopeRelationAndEventNetwork.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - CreateEnvelopeRelationAndEventNetwork

struct CreateEnvelopeRelationAndEventNetwork {
  var getRelationItems: @Sendable () async throws -> [CreateEnvelopeRelationItemProperty]
  @Sendable private static func _getRelationItems() async throws -> [CreateEnvelopeRelationItemProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getItems)
    return dto.relationships
  }

  var getEventItems: @Sendable () async throws -> [CreateEnvelopeCategoryProperty]
  @Sendable private static func _getEventItems() async throws -> [CreateEnvelopeCategoryProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getItems)
    return dto.categories.sorted { $0.seq < $1.seq }
  }
}

// MARK: DependencyKey

extension CreateEnvelopeRelationAndEventNetwork: DependencyKey {
  static var liveValue: CreateEnvelopeRelationAndEventNetwork = .init(
    getRelationItems: _getRelationItems,
    getEventItems: _getEventItems
  )

  private static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  enum Network: SSNetworkTargetType {
    case getItems

    var additionalHeader: [String: String]? { nil }
    var path: String { "envelopes/configs/create-envelopes" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
  }
}

extension DependencyValues {
  var createEnvelopeRelationAndEventNetwork: CreateEnvelopeRelationAndEventNetwork {
    get { self[CreateEnvelopeRelationAndEventNetwork.self] }
    set { self[CreateEnvelopeRelationAndEventNetwork.self] = newValue }
  }
}
