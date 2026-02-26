//
//  RegexManager.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum RegexManager {
  private static func makeRegex(_ pattern: String) -> Regex<Substring>? {
    return try? Regex(pattern)
  }

  private nonisolated(unsafe) static let nameRegex: Regex<Substring>? = makeRegex(RegexPatternString.name.regexString)

  @Sendable public static func isValidName(_ name: String) -> Bool {
    guard let nameRegex else { return false }
    return name.contains(nameRegex)
  }

  private nonisolated(unsafe) static let priceRegex: Regex<Substring>? = makeRegex(RegexPatternString.price.regexString)

  @Sendable public static func isValidPrice(_ value: String) -> Bool {
    guard let priceRegex else { return false }
    return value.contains(priceRegex)
  }

  private nonisolated(unsafe) static let relationRegex: Regex<Substring>? = makeRegex(RegexPatternString.relationship.regexString)

  @Sendable public static func isValidCustomRelationShip(_ value: String) -> Bool {
    guard let relationRegex else { return false }
    return value.contains(relationRegex)
  }

  private nonisolated(unsafe) static let categoryRegex: Regex<Substring>? = makeRegex(RegexPatternString.category.regexString)

  @Sendable public static func isValidCustomCategory(_ value: String) -> Bool {
    guard let categoryRegex else { return false }
    return value.contains(categoryRegex)
  }

  private nonisolated(unsafe) static let ledgerRegex: Regex<Substring>? = makeRegex(RegexPatternString.ledger.regexString)

  @Sendable public static func isValidLedgerName(_ name: String) -> Bool {
    guard let ledgerRegex else { return false }
    return name.contains(ledgerRegex)
  }

  private nonisolated(unsafe) static let giftRegex: Regex<Substring>? = makeRegex(RegexPatternString.gift.regexString)

  @Sendable public static func isValidGift(_ value: String) -> Bool {
    guard let giftRegex else { return false }
    return value.contains(giftRegex)
  }

  private nonisolated(unsafe) static let memoRegex: Regex<Substring>? = makeRegex(RegexPatternString.memo.regexString)

  @Sendable public static func isValidMemo(_ value: String) -> Bool {
    guard let memoRegex else { return false }
    return value.contains(memoRegex)
  }

  private nonisolated(unsafe) static let concatsRegex: Regex<Substring>? = makeRegex(RegexPatternString.contacts.regexString)

  @Sendable public static func isValidContacts(_ value: String) -> Bool {
    guard let concatsRegex else { return false }
    return value.contains(concatsRegex)
  }

  private nonisolated(unsafe) static let voteContentRegex: Regex<Substring>? = makeRegex(RegexPatternString.voteContents.regexString)

  @Sendable public static func isValidVoteContent(_ value: String) -> Bool {
    guard let voteContentRegex else { return false }
    return value.contains(voteContentRegex)
  }
}
