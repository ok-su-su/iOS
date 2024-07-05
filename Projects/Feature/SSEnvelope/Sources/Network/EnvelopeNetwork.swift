//
//  EnvelopeNetwork.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - EnvelopeNetwork

struct EnvelopeNetwork {
  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelopeDetailPropertyByEnvelopeID(_ id: Int64) async throws -> EnvelopeDetailProperty {
    let data: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(id))
    return .init(
      id: data.envelope.id,
      price: data.envelope.amount,
      eventName: data.category.customCategory != nil ? data.category.customCategory! : data.category.category,
      name: data.friend.name,
      relation: data.friendRelationship.customRelation != nil ? data.friendRelationship.customRelation! : data.relationship.relation,
      date: .getDate(from: data.envelope.handedOverAt) ?? .now,
      isVisited: data.envelope.hasVisited,
      gift: data.envelope.gift,
      contacts: data.friend.phoneNumber,
      memo: data.envelope.memo
    )
  }

  func deleteEnvelope(id: Int64) async throws {
    try await provider.request(.deleteEnvelope(envelopeID: id))
  }

  func getSpecificEnvelopeHistoryEditHelperBy(envelopeID: Int64) async throws -> SpecificEnvelopeEditHelper {
    // 맨 뒤 기타는 제거 합니다.
    var events = try await getEventItems()
    _ = events.popLast()
    // 맨 뒤 기타는 제거 합니다.
    var relations = try await getRelationItems()
    _ = relations.popLast()

    return try await .init(
      envelopeDetailProperty: getEnvelopeDetailPropertyByEnvelopeID(envelopeID),
      eventItems: events,
      relationItems: relations
    )
  }

  private func getRelationItems() async throws -> [CreateEnvelopeRelationItemProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getEditItems)
    return dto.relationships.map { .init(id: $0.id, title: $0.relation) }
  }

  private func getEventItems() async throws -> [CreateEnvelopeEventProperty] {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getEditItems)
    return dto.categories.map { .init(id: $0.id, title: $0.name) }
  }
}

extension DependencyValues {
  var envelopeNetwork: EnvelopeNetwork {
    get { self[EnvelopeNetwork.self] }
    set { self[EnvelopeNetwork.self] = newValue }
  }
}

// MARK: - EnvelopeNetwork + DependencyKey

extension EnvelopeNetwork: DependencyKey {
  static var liveValue: EnvelopeNetwork = .init()

  enum Network: SSNetworkTargetType {
    case deleteEnvelope(envelopeID: Int64)
    case searchEnvelopeByID(Int64)
    case getEditItems

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case let .searchEnvelopeByID(id):
        "envelopes/\(id)"
      case let .deleteEnvelope(envelopeID: id):
        "envelopes/\(id)"
      case .getEditItems:
        "envelopes/configs/create-envelopes"
      }
    }

    var method: Moya.Method {
      switch self {
      case .deleteEnvelope:
        return .delete
      default:
        return .get
      }
    }

    var task: Moya.Task {
      switch self {
      case .searchEnvelopeByID:
        return .requestPlain

      case .deleteEnvelope:
        return .requestPlain

      case .getEditItems:
        return .requestPlain
      }
    }
  }
}

private extension Date {
  private static let `default` = DateFormatter()
  // yyyy-MM-dd'T'HH:mm:ss.SSS... String을 Date로 변환시켜 줍니다.
  static func getDate(from val: String) -> Date? {
    `default`.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let targetString = String(val.prefix(19))
    return `default`.date(from: targetString)
  }
}
