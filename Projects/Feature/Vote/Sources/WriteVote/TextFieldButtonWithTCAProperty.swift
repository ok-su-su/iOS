//
//  TextFieldButtonWithTCAProperty.swift
//  Vote
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

// MARK: - TextFieldButtonWithTCAProperty

/// Regex<Substring>이 sendable을 채택하지 않음
struct TextFieldButtonWithTCAProperty: TextFieldButtonWithTCAPropertiable, @unchecked Sendable {
  static func == (lhs: TextFieldButtonWithTCAProperty, rhs: TextFieldButtonWithTCAProperty) -> Bool {
    if lhs.id == rhs.id,
       lhs.title == rhs.title,
       lhs.isSaved == rhs.isSaved,
       lhs.isEditing == rhs.isEditing {
      return true
    } else { return false }
  }

  var id: Int
  var title: String
  var isSaved: Bool
  var isEditing: Bool
  var regexString: Regex<Substring>?

  mutating func deleteTextFieldText() {}

  mutating func deleteTextField() {}

  mutating func savedTextField() {}

  mutating func editTextField(text: String) {
    title = text
  }

  init(id: Int, title: String, isSaved: Bool, isEditing: Bool, regexString: Regex<Substring>?) {
    self.id = id
    self.title = title
    self.isSaved = isSaved
    self.isEditing = isEditing
    self.regexString = regexString
  }

  init(id: Int, regexString: Regex<Substring>?) {
    self.id = id
    self.regexString = regexString
    title = ""
    isSaved = false
    isEditing = true
  }
}

extension [TextFieldButtonWithTCAProperty] {
  private static let defaultPropertyItemsCount: Int = 2
  @Sendable static func `default`() -> Self {
    return (0 ..< defaultPropertyItemsCount).map { .init(id: $0, regexString: TextFieldButtonWithTCAProperty.defaultRegex) }
  }
}

extension TextFieldButtonWithTCAProperty {
  private static let defaultRegexPattern: String = "^.{1,10}$"
  nonisolated(unsafe) static let defaultRegex: Regex<Substring> = try! .init(defaultRegexPattern)
}

extension TextFieldButtonWithTCAProperty {
  @Sendable static func convertFromVoteOptionCountModel(_ dto: VoteOptionCountModel) -> Self {
    return .init(
      id: Int(dto.id),
      title: dto.content,
      isSaved: true,
      isEditing: false,
      regexString: defaultRegex
    )
  }
}
