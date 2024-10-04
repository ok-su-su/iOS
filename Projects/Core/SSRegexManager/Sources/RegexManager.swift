//
//  RegexManager.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum RegexManager {
  private nonisolated(unsafe) static let nameRegex: Regex<Substring> = try! Regex(RegexPatternString.name.regexString)

  @Sendable public static func isValidName(_ name: String) -> Bool {
    return name.contains(nameRegex)
  }

  private nonisolated(unsafe) static let priceRegex: Regex<Substring> = try! Regex(RegexPatternString.price.regexString)

  @Sendable public static func isValidPrice(_ value: String) -> Bool {
    return value.contains(priceRegex)
  }

  private nonisolated(unsafe) static let relationRegex: Regex<Substring> = try! Regex(RegexPatternString.relationship.regexString)

  @Sendable public static func isValidCustomRelationShip(_ value: String) -> Bool {
    return value.contains(relationRegex)
  }

  private nonisolated(unsafe) static let categoryRegex: Regex<Substring> = try! Regex(RegexPatternString.category.regexString)

  @Sendable public static func isValidCustomCategory(_ value: String) -> Bool {
    return value.contains(categoryRegex)
  }

  private nonisolated(unsafe) static let ledgerRegex: Regex<Substring> = try! Regex(RegexPatternString.ledger.regexString)

  @Sendable public static func isValidLedgerName(_ name: String) -> Bool {
    return name.contains(ledgerRegex)
  }

  private nonisolated(unsafe) static let giftRegex: Regex<Substring> = try! Regex(RegexPatternString.gift.regexString)

  @Sendable public static func isValidGift(_ value: String) -> Bool {
    return value.contains(giftRegex)
  }

  private nonisolated(unsafe) static let memoRegex: Regex<Substring> = try! Regex(RegexPatternString.memo.regexString)

  @Sendable public static func isValidMemo(_ value: String) -> Bool {
    return value.contains(memoRegex)
  }

  private nonisolated(unsafe) static let concatsRegex: Regex<Substring> = try! Regex(RegexPatternString.contacts.regexString)

  @Sendable public static func isValidContacts(_ value: String) -> Bool {
    return value.contains(concatsRegex)
  }

  private nonisolated(unsafe) static let voteContentRegex: Regex<Substring> = try! Regex(RegexPatternString.voteContents.regexString)

  @Sendable public static func isValidVoteContent(_ value: String) -> Bool {
    return value.contains(voteContentRegex)
  }
}
