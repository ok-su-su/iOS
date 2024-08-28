//
//  UserBlockTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum UserBlockTargetType: CustomStringConvertible, Equatable {
  public var description: String {
    switch self {
    case .user:
      "USER"
    case .post:
      "POST"
    }
  }

  /// 유저
  case user

  /// 게시글
  case post
}
