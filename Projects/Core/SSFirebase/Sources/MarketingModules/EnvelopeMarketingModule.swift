//
//  EnvelopeMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum EnvelopeMarketingModule: CustomStringConvertible, Equatable {
  case detail
  case edit
  public var description: String {
    switch self {
    case .detail:
      "봉투 상세"
    case .edit:
      "봉투 수정"
    }
  }
}
