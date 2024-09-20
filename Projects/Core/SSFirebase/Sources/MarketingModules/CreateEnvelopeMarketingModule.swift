//
//  CreateEnvelopeMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum CreateEnvelopeMarketingModule: CustomStringConvertible, Equatable {
  case price
  case name
  case relation
  case category
  case date
  case additionalSection
  case memo
  case contact
  case gift
  case isVisited
  case error

  public var description: String {
    switch self {
    case .price:
      "가격"
    case .name:
      "이름"
    case .relation:
      "관계"
    case .category:
      "카테고리"
    case .date:
      "날짜"
    case .additionalSection:
      "추가 선택"
    case .memo:
      "이름"
    case .contact:
      "연락처"
    case .gift:
      "선물"
    case .isVisited:
      "방문 여부"
    case .error:
      "오류"
    }
  }
}
