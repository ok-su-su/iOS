//
//  UserInfoResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - UserInfoResponseDTO

public struct UserInfoResponse: Equatable, Decodable, Sendable {
  /// 내 아이디
  public let id: Int64
  /// 내 이름
  public let name: String
  /// 성별 M: 남자, W 여자
  public let gender: String?
  /// 출생 년도
  public let birth: Int?

  public init(id: Int64, name: String, gender: String?, birth: Int?) {
    self.id = id
    self.name = name
    self.gender = gender
    self.birth = birth
  }
}
