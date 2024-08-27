//
//  UserBlockTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum UserBlockTargetType: Encodable, Equatable  {
  /** 유저 */
  case user
  
  /** 게시글 */
  case post
  enum CodingKeys: String, CodingKey {
    case user = "USER"
    case post = "POST"
  }
}
