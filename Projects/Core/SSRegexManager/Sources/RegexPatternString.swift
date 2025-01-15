//
//  RegexPatternString.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum RegexPatternString {
  case name
  case price
  case relationship
  case category
  case ledger
  case gift
  case memo
  case contacts
  case voteContents

  public var regexString: String {
    switch self {
    case .name:
      "^.{1,10}$"
    case .price:
      "^[\\d]{1,10}$"
    case .relationship:
      "^.{1,10}$"
    case .category:
      "^.{1,10}$"
    case .ledger:
      "^.{1,10}$"
    case .gift:
      "^.{1,30}$"
    case .memo:
      "^.{1,30}$"
    case .contacts:
      "^[\\d]{11}$"
    case .voteContents:
      "^[\\s\\S]{1,200}$"
    }
  }
}
