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

  static func resetBody() {
    shared.body = .init()
  }

  static func getRequestBodyData() throws -> Data {
    let body = shared.body
    guard let title = body.title,
          let categoryId = body.categoryId,
          let startAt = body.startAt,
          let endAt = body.endAt
    else {
      throw CreateLedgerSharedStateError.cantMakeCreateLedgerBody
    }

    let startAtString = CustomDateFormatter.getFullDateString(from: startAt)
    let endAtString = CustomDateFormatter.getFullDateString(from: endAt)
    let dto = CreateAndUpdateLedgerRequestDTO(
      title: title,
      description: body.description,
      categoryId: categoryId,
      customCategory: body.customCategory,
      startAt: startAtString,
      endAt: endAtString
    )

    return try JSONEncoder().encode(dto)
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

// MARK: - CreateAndUpdateLedgerRequestDTO

struct CreateAndUpdateLedgerRequestDTO: Encodable {
  let title: String
  let description: String?
  let categoryId: Int
  let customCategory: String?
  let startAt: String
  let endAt: String

  enum CodingKeys: CodingKey {
    case title
    case description
    case categoryId
    case customCategory
    case startAt
    case endAt
  }
}

// MARK: - CreateLedgerSharedStateError

enum CreateLedgerSharedStateError: LocalizedError {
  case cantMakeCreateLedgerBody

  var errorDescription: String? {
    switch self {
    case .cantMakeCreateLedgerBody:
      return "장부를 만들기 위한 바디를 만들 수 없습니다."
    }
  }
}
