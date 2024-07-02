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

extension DependencyValues {
  var createEnvelopeRelationAndEventNetwork: CreateEnvelopeRelationAndEventNetwork {
    get { self[CreateEnvelopeRelationAndEventNetwork.self] }
    set { self[CreateEnvelopeRelationAndEventNetwork.self] = newValue }
  }
}

// MARK: - CreateEnvelopeRelationAndEventNetwork

struct CreateEnvelopeRelationAndEventNetwork: DependencyKey, Equatable {
  static func == (_: CreateEnvelopeRelationAndEventNetwork, _: CreateEnvelopeRelationAndEventNetwork) -> Bool {
    true
  }

  static var liveValue: CreateEnvelopeRelationAndEventNetwork = .init()

  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))

  func getRelationItems() async throws -> [CreateEnvelopeRelationItemProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getItems)
    return dto.relationships.map { .init(id: $0.id, title: $0.relation) }
  }

  func getEventItems() async throws -> [CreateEnvelopeEventProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getItems)
    return dto.categories.map { .init(id: $0.id, title: $0.name) }
  }
}

// MARK: CreateEnvelopeRelationAndEventNetwork.Network

extension CreateEnvelopeRelationAndEventNetwork {
  enum Network: SSNetworkTargetType {
    case getItems

    var additionalHeader: [String: String]? { nil }
    var path: String { "envelopes/configs/create-envelopes" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
  }
}
