//
//  CreateLedgerSharedState.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateLedgerSharedState

final class CreateLedgerSharedState {
  private var body = CreateAndUpdateLedgerRequest()

  private static let shared: CreateLedgerSharedState = .init()

  static func setTitle(_ title: String?) {
    shared.body.title = title
  }

  static func setDescription(_ description: String) {
    shared.body.description = description
  }

  static func setCategoryID(_ id: Int) {
    shared.body.categoryId = id
  }

  static func setCustomCategory(_ name: String) {
    shared.body.customCategory = name
  }

  static func setStartDate(_ date: Date) {
    shared.body.startAt = date
  }

  static func setEndDate(_ date: Date) {
    shared.body.endAt = date
  }

  static func getBody() -> CreateAndUpdateLedgerRequest {
    shared.body
  }
}

// MARK: - CreateAndUpdateLedgerRequest

struct CreateAndUpdateLedgerRequest: Encodable {
  var title: String?
  var description: String?
  var categoryId: Int?
  var customCategory: String?
  var startAt: Date?
  var endAt: Date?

  enum CodingKeys: CodingKey {
    case title
    case description
    case categoryId
    case customCategory
    case startAt
    case endAt
  }
}
