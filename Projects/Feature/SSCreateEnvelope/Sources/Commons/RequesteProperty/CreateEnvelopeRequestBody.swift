//
//  CreateEnvelopeRequestBody.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

// MARK: - CreateEnvelopeRequestBody

struct CreateEnvelopeRequestBody: Codable, Equatable {
  /// 봉투의 SENT혹은 RECIVE를 통해 타입을 전달합니다.
  public var type: String
  /// 봉투의 친구 ID입니다.
  public var friendID: Int64? = nil
  /// NIL
  public var ledgerID: Int64? = nil
  /// 봉투의 총액입니다.
  public var amount: Int64? = nil
  /// 어떤 선물을 주고받았는지 활용됩니다.
  public var gift: String? = nil
  /// 메모 입니다.
  public var memo: String? = nil
  /// 방문 여부를 나타냅니다.
  public var hasVisited: Bool? = nil
  /// 건넨 날짜를 입력받습니다.
  public var handedOverAt: String? = nil
  /// 경조사에 대해서 나타냅니다.
  public var category: CategoryRequestBody?

  public init(type: CreateType) {
    self.type = type.key
  }

  init(
    type: String,
    friendID: Int64? = nil,
    ledgerID: Int64? = nil,
    amount: Int64? = nil,
    gift: String? = nil,
    memo: String? = nil,
    hasVisited: Bool? = nil,
    handedOverAt: String? = nil,
    category: CategoryRequestBody? = nil
  ) {
    self.type = type
    self.friendID = friendID
    self.ledgerID = ledgerID
    self.amount = amount
    self.gift = gift
    self.memo = memo
    self.hasVisited = hasVisited
    self.handedOverAt = handedOverAt
    self.category = category
  }

  enum CodingKeys: String, CodingKey {
    case type
    case friendID = "friendId"
    case ledgerID = "ledgerId"
    case amount
    case gift
    case memo
    case hasVisited
    case handedOverAt
    case category
  }
}

extension CreateEnvelopeRequestBody {
  func getData() -> Data {
    do {
      return try JSONEncoder.default.encode(self)
    } catch {
      os_log("Json Encoding에 실패했습니다. \(#function)\n\(error.localizedDescription)")
      return Data()
    }
  }
}

// MARK: - CategoryRequestBody

struct CategoryRequestBody: Codable, Equatable {
  var id: Int?
  var customCategory: String?
  var name: String?

  public init(id: Int? = nil, name: String? = nil, customCategory: String? = nil) {
    self.id = id
    self.name = name
    self.customCategory = customCategory
  }

  enum CodingKeys: String, CodingKey {
    case id
    case customCategory
    case name
  }
}

extension JSONEncoder {
  static let `default` = JSONEncoder()
}
