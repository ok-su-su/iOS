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
  static let provider: MoyaProvider<Network> = .init(session: .init(interceptor: SSTokenInterceptor.shared))

  var getEnvelopeDetailPropertyByEnvelopeID: @Sendable (_ id: Int64) async throws -> EnvelopeDetailProperty
  @Sendable static func _getEnvelopeDetailPropertyByEnvelopeID(_ id: Int64) async throws -> EnvelopeDetailProperty {
    let data: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(id))
    return data.convertToEnvelopeDetailLProperty()
  }

  var deleteEnvelope: @Sendable (_ id: Int64) async throws -> Void
  @Sendable private static func _deleteEnvelope(id: Int64) async throws {
    try await provider.request(.deleteEnvelope(envelopeID: id))
  }

  var getSpecificEnvelopeHistoryEditHelperBy: @Sendable (_ envelopeID: Int64) async throws -> SpecificEnvelopeEditHelper
  @Sendable private static func _getSpecificEnvelopeHistoryEditHelperBy(envelopeID: Int64) async throws -> SpecificEnvelopeEditHelper {
    let (responseEvents, responseRelations) = try await getCategoryAndRelationItem()
    let events = responseEvents.sorted{$0.seq < $1.seq }
    let relations = responseRelations.sorted{$0.id < $1.id}

    let envelopeDetailResponse: EnvelopeDetailResponse = try await provider.request(.searchEnvelopeByID(envelopeID))
    let envelopeProperty = envelopeDetailResponse.convertToEnvelopeDetailLProperty()

    guard var customCategoryItem = events.first(where: { $0.isCustom }),
          var customRelationItem = relations.first(where: { $0.isCustom })
    else {
      throw NSError(domain: "", code: 3)
    }
    let targetCategoryItems = events.filter { $0.isCustom == false }
    let targetRelationItems = relations.filter { $0.isCustom == false }

    customCategoryItem.title = envelopeDetailResponse.category.customCategory ?? ""
    customRelationItem.title = envelopeDetailResponse.friendRelationship.customRelation ?? ""

    return .init(
      envelopeDetailProperty: envelopeProperty,
      eventItems: targetCategoryItems,
      customEventItem: customCategoryItem,
      relationItems: targetRelationItems,
      customRelationItem: customRelationItem
    )
  }

  var editFriends: @Sendable (_ id: Int64, _ body: CreateAndUpdateFriendRequest) async throws -> Int64
  @Sendable private static func _editFriends(id: Int64, body: CreateAndUpdateFriendRequest) async throws -> Int64 {
    let dto: CreateAndUpdateFriendResponse = try await provider.request(.editFriends(id: id, body))
    return dto.id
  }

  var editEnvelopes: @Sendable (_ id: Int64, _ body: CreateAndUpdateEnvelopeRequest) async throws -> EnvelopeDetailProperty
  @Sendable private static func _editEnvelopes(id: Int64, body: CreateAndUpdateEnvelopeRequest) async throws -> EnvelopeDetailProperty {
    // TODO: 작업하기
    let dto: CreateAndUpdateEnvelopeResponse = try await provider.request(.editEnvelopes(id: id, body))
    return .init(
      id: dto.envelope.id,
      type: dto.envelope.type,
      ledgerID: nil,
      price: dto.envelope.amount,
      eventName: dto.category.customCategory ?? dto.category.category,
      eventID: dto.category.id,
      friendID: dto.friend.id,
      name: dto.friend.name,
      relation: dto.friendRelationship.customRelation ?? dto.relationship.relation,
      relationID: dto.relationship.id,
      date: CustomDateFormatter.getDate(from: dto.envelope.handedOverAt) ?? .now,
      isVisited: dto.envelope.hasVisited,
      gift: dto.envelope.gift,
      contacts: dto.friend.phoneNumber,
      memo: dto.envelope.memo
    )
  }

  private static func getCategoryAndRelationItem() async throws -> ([CreateEnvelopeEventProperty], [CreateEnvelopeRelationItemProperty]) {
    let dto: CreateEnvelopesConfigResponse = try await provider.request(.getEditItems)
    let categories = dto.categories.sorted(by: { $0.seq < $1.seq })
    let relationships = dto.relationships.sorted(by: { $0.id < $1.id })
    return (categories, relationships)
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
  static var liveValue: EnvelopeNetwork = .init(
    getEnvelopeDetailPropertyByEnvelopeID: _getEnvelopeDetailPropertyByEnvelopeID,
    deleteEnvelope: _deleteEnvelope,
    getSpecificEnvelopeHistoryEditHelperBy: _getSpecificEnvelopeHistoryEditHelperBy,
    editFriends: _editFriends,
    editEnvelopes: _editEnvelopes
  )

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

private extension EnvelopeDetailResponse {
  func convertToEnvelopeDetailLProperty() -> EnvelopeDetailProperty {
    let data = self
    return .init(
      id: data.envelope.id,
      type: data.envelope.type,
      ledgerID: nil,
      price: data.envelope.amount,
      eventName: data.category.customCategory ?? data.category.category,
      eventID: data.category.id,
      friendID: data.friend.id,
      name: data.friend.name,
      relation: data.friendRelationship.customRelation != nil ? data.friendRelationship.customRelation! : data.relationship.relation,
      relationID: data.relationship.id,
      date: .getDate(from: data.envelope.handedOverAt) ?? .now,
      isVisited: data.envelope.hasVisited,
      gift: data.envelope.gift,
      contacts: data.friend.phoneNumber,
      memo: data.envelope.memo
    )
  }
}
