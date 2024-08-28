//
//  ReportTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum ReportTargetType: Encodable {
  /// 사용자 (User)
  case user
  /// 게시글 (Post)
  case post

  enum CodingKeys: String, CodingKey {
    case user = "USER"
    case post = "POST"
  }
}
