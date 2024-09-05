//
//  MyPageMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - MyPageMarketingModule

public enum MyPageMarketingModule: CustomStringConvertible, Equatable {
  case main
  public var description: String {
    switch self {
    case .main:
      "메인"
    }
  }
}
