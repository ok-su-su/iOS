//
//  CreateEnvelopeRequestBody.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeRequestBody

struct CreateEnvelopeRequestBody: Codable, Equatable {
  let type: String
  let friendID: Int? = nil
  let ledgerID: Int? = nil
  let amount: Int? = nil
  let gift: String? = nil
  let memo: String? = nil
  let hasVisited: Bool? = nil
  let handedOverAt: String? = nil
  let category: CategoryRequestBody? = nil

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

// MARK: - CategoryRequestBody

struct CategoryRequestBody: Codable, Equatable {
  let id: Int
  let customCategory: String?

  enum CodingKeys: String, CodingKey {
    case id
    case customCategory
  }
}
