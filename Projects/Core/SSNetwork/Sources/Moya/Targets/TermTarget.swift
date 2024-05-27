//
//  TermTarget.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

enum TermTarget {
  case terms
  case termId(id: Int)
}

extension TermTarget: BaseTargetType {
  
  var path: String {
    switch self {
    case .terms:
      return "/terms"
    case let .termId(id):
      return "/terms/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .terms:
      return .get
    case .termId:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .terms:
      return .requestPlain
    case .termId:
      return .requestPlain
    }
  }
  
}
