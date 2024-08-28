//
//  ReportTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum ReportTargetType: CustomStringConvertible, Equatable, Encodable {
  /// 사용자 (User)
  case user
  /// 게시글 (Post)
  case post

  public var description: String {
    switch self {
    case .user:
      "USER"
    case .post:
      "POST"
    }
  }

  enum CodingKeys: String, CodingKey {
    case user = "USER"
    case post = "POST"
  }
}
