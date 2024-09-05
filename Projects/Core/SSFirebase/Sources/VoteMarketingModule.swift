//
//  VoteMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - VoteMarketingModule

public enum VoteMarketingModule: CustomStringConvertible, Equatable {
  case main
  case write
  case search
  case edit
  case detail
  public var description: String {
    switch self {
    case .main:
      "메인"
    case .write:
      "쓰기"
    case .search:
      "검색"
    case .edit:
      "수정"
    case .detail:
      "상세"
    }
  }
}
