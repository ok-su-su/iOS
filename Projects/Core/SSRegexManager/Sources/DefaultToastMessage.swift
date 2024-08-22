//
//  DefaultToastMessage.swift
//  SSRegexManager
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum DefaultToastMessage: CustomStringConvertible {
  case price
  case name
  case relation
  case category
  case ledger
  case gift
  case memo
  case contact
  public var description: String {
    switch self {
    case .price:
      "100억 미만의 금액만 입력 가능해요"
    case .name:
      "이름은 10글자까지만 입력 가능해요"
    case .relation:
      "나와의 관계는 10글자까지만 입력 가능해요"
    case .category:
      "경조사는 10글자까지만 입력 가능해요"
    case .ledger:
      "경조사 명은 10글자까지만 입력 가능해요"
    case .gift:
      "선물은 30글자까지만 입력 가능해요"
    case .memo:
      "메모는 30글자까지만 입력 가능해요"
    case .contact:
      "연락처는 11자리까지만 입력 가능해요"
    }
  }

  public var message: String { description }
}
