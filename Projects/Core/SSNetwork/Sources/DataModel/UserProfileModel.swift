//
//  UserProfileModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct UserProfileModel: Equatable, Decodable {
  /// 유저 id
  public let id: Int64
  /// 이름
  public let name: String
  /// 프로필 사진 url
  public let profileImageUrl: String?

  enum CodingKeys: CodingKey {
    case id
    case name
    case profileImageUrl
  }
}
