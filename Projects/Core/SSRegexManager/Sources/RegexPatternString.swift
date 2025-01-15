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
      "^\\S(?:.{0,8}\\S)?$"
    case .price:
      "^[\\d]{1,10}$"
    case .relationship:
      "^\\S(?:.{0,8}\\S)?$"
    case .category:
      "^\\S(?:.{0,8}\\S)?$"
    case .ledger:
      "^\\S(?:.{0,8}\\S)?$"
    case .gift:
      "^\\S(?:.{0,28}\\S)?$"
    case .memo:
      "^\\S(?:.{0,28}\\S)?$"
    case .contacts:
      "^[\\d]{11}$"
    case .voteContents:
      "^[\\s\\S]{1,200}$"
    }
  }
}
