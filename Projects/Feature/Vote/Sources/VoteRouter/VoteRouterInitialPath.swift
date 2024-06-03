//
//  VoteRouterInitialPath.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

/// VoteRouter 화면전환시 첫 화면에 대한 구조체 입니다.
enum VoteRouterInitialPath: Equatable {
  case search
  case voteDetail(VoteDetailType)
  case write

  enum VoteDetailType {
    case mine
    case other
  }
}
