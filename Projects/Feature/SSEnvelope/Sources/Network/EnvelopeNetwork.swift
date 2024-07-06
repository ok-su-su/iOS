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
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - EnvelopeNetwork

struct EnvelopeNetwork {
  private let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  func getEnvelopeDetailPropertyByEnvelopeID(_ id: Int64) async throws -> EnvelopeDetailProperty {
    let data: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(id))
    return .init(
      id: data.envelope.id,
      type: data.envelope.type,
      ledgerID: nil,
      price: data.envelope.amount,
      eventName: data.category.customCategory != nil ? data.category.customCategory! : data.category.category,
      friendID: data.friend.id,
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

  func editFriends(id: Int64, body: CreateAndUpdateFriendRequest) async throws -> Int64 {
    let dto: CreateAndUpdateFriendResponse = try await provider.request(.editFriends(id: id, body))
    return dto.id
  }

  func editEnvelopes(id: Int64, body: CreateAndUpdateEnvelopeRequest) async throws {
    // TODO: 작업하기
    let dto: CreateAndUpdateEnvelopeResponse = try await provider.request(.editEnvelopes(id: id, body))
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
    case editFriends(id: Int64, CreateAndUpdateFriendRequest)
    case editEnvelopes(id: Int64, CreateAndUpdateEnvelopeRequest)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case let .searchEnvelopeByID(id):
        "envelopes/\(id)"
      case let .deleteEnvelope(envelopeID: id):
        "envelopes/\(id)"
      case .getEditItems:
        "envelopes/configs/create-envelopes"
      case let .editFriends(id, _):
        "friends/\(id)"
      case let .editEnvelopes(id, _):
        "envelopes/\(id)"
      }
    }

    var method: Moya.Method {
      switch self {
      case .deleteEnvelope:
        return .delete

      case .editFriends:
        return .put

      case .editEnvelopes:
        return .patch

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
      case let .editFriends(_, property):
        return .requestData(encode(property))

      case let .editEnvelopes(_, property):
        return .requestData(encode(property))
      }
    }

    func encode(_ value: Encodable) -> Data {
      do {
        return try EnvelopeNetwork.Network.encoder.encode(value)
      } catch {
        os_log("\(error.localizedDescription)")
        return Data()
      }
    }

    private static let encoder = JSONEncoder()
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
