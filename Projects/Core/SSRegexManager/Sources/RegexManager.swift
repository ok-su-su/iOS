//
//  RegexManager.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum RegexManager {
  public static func isValidName(_ name: String) -> Bool {
    let regex = /^[가-힣|a-z|A-Z|0-9| |.]{1,10}$/
    return name.contains(regex)
  }

  public static func isValidPrice(_ value: String) -> Bool {
    let regex = /^[\d]{1,10}$/
    return value.contains(regex)
  }

  public static func isValidCustomRelationShip(_ value: String) -> Bool {
    let regex = /^[가-힣|a-z|A-Z| ]{1,10}$/
    return value.contains(regex)
  }

  public static func isValidCustomCategory(_ value: String) -> Bool {
    let regex = /^[가-힣|a-z|A-Z| ]{1,10}$/
    return value.contains(regex)
  }

  public static func isValidLedgerName(_ name: String) -> Bool {
    let regex = /^[가-힣|a-z|A-Z| ]{1,10}$/
    return name.contains(regex)
  }

  public static func isValidGift(_ value: String) -> Bool {
    let regex = /^[가-힣|a-z|A-Z|0-9| ]{1,30}$/
    return value.contains(regex)
  }

  public static func isValidMemo(_ value: String) -> Bool {
    let valueCount = value.count
    return valueCount > 0 && valueCount <= 30
  }

  public static func isValidContacts(_ value: String) -> Bool {
    let regex = /^[\d]{11}$/
    return value.contains(regex)
  }
}
