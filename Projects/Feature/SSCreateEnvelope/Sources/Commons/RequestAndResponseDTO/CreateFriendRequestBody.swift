//
//  CreateFriendRequestBody.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

// MARK: - CreateFriendRequestBody

struct CreateFriendRequestBody: Codable, Equatable {
  var name: String? = nil
  var phoneNumber: String? = nil
  var relationshipId: Int? = nil
  var customRelation: String? = nil

  enum CodingKeys: CodingKey {
    case name
    case phoneNumber
    case relationshipId
    case customRelation
  }
}

extension CreateFriendRequestBody {
  func parameters() -> [String: Any] {
    var res: [String: Any] = [:]
    if let name {
      res["name"] = name
    }
    return res
  }

  func getData() -> Data {
    let jsonEncoder = JSONEncoder()
    do {
      return try jsonEncoder.encode(self)
    } catch {
      os_log("Json Encoding에 실패했습니다.\(#function)\n\(error.localizedDescription)")
      return Data()
    }
  }
}
