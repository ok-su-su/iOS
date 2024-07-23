//
//  RegexManager.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum RegexManager {
  private static let nameRegex: Regex<Substring> = try! Regex(RegexPatternString.name.regexString)

  public static func isValidName(_ name: String) -> Bool {
    return name.contains(nameRegex)
  }

  private static let priceRegex: Regex<Substring> = try! Regex(RegexPatternString.price.regexString)

  public static func isValidPrice(_ value: String) -> Bool {
    return value.contains(priceRegex)
  }

  private static let relationRegex: Regex<Substring> = try! Regex(RegexPatternString.relationship.regexString)

  public static func isValidCustomRelationShip(_ value: String) -> Bool {
    return value.contains(relationRegex)
  }

  private static let categoryRegex: Regex<Substring> = try! Regex(RegexPatternString.category.regexString)

  public static func isValidCustomCategory(_ value: String) -> Bool {
    return value.contains(categoryRegex)
  }

  private static let ledgerRegex: Regex<Substring> = try! Regex(RegexPatternString.ledger.regexString)

  public static func isValidLedgerName(_ name: String) -> Bool {
    return name.contains(ledgerRegex)
  }

  private static let giftRegex: Regex<Substring> = try! Regex(RegexPatternString.gift.regexString)

  public static func isValidGift(_ value: String) -> Bool {
    return value.contains(giftRegex)
  }

  private static let memoRegex: Regex<Substring> = try! Regex(RegexPatternString.memo.regexString)

  public static func isValidMemo(_ value: String) -> Bool {
    return value.contains(memoRegex)
  }

  private static let concatsRegex: Regex<Substring> = try! Regex(RegexPatternString.contacts.regexString)

  public static func isValidContacts(_ value: String) -> Bool {
    return value.contains(concatsRegex)
  }
}
