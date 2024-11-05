//
//  CreateEnvelopeViewTypes.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 11/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

@frozen
public enum CreateEnvelopeViewTypes: CustomStringConvertible {
  public var description: String {
    switch self {
    case .price:
      "금액"
    case .name:
      "이름"
    case .relation:
      "관계"
    case .ledger:
      "장부"
    case .date:
      "날짜"
    case .isVisited:
      "방문여부"
    case .phoneNumber:
      "연락처"
    case .memo:
      "메모"
    case .selectAdditional:
      "추가 선택"
    case .gift:
      "선물"
    case .category:
      "경조사"
    }
  }

  case price
  case name
  case relation
  case ledger
  case category
  case date
  case isVisited
  case phoneNumber
  case memo
  case selectAdditional
  case gift
}
