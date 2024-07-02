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
  var type: String
  /// 봉투의 친구 ID입니다.
  var friendID: Int64? = nil
  /// NIL
  var ledgerID: Int64? = nil
  /// 봉투의 총액입니다.
  var amount: Int64? = nil
  /// 어떤 선물을 주고받았는지 활용됩니다.
  var gift: String? = nil
  /// 메모 입니다.
  var memo: String? = nil
  /// 방문 여부를 나타냅니다.
  var hasVisited: Bool? = nil
  /// 건넨 날짜를 입력받습니다.
  var handedOverAt: String? = nil
  /// 경조사에 대해서 나타냅니다.
  var category: CategoryRequestBody?

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

  enum CodingKeys: String, CodingKey {
    case id
    case customCategory
  }
}

extension JSONEncoder {
  static var `default` = JSONEncoder()
}