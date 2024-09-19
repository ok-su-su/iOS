//
//  CreateLedgerMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum CreateLedgerMarketingModule: CustomStringConvertible, Equatable {
  case category
  case name
  case date
  public var description: String {
    switch self {
    case .category:
      "장부생성 카테고리"
    case .name:
      "장부생성 이름"
    case .date:
      "장부생성 날짜"
    }
  }
}
