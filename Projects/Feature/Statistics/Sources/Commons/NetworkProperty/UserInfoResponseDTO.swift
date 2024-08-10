//
//  UserInfoResponseDTO.swift
//  Statistics
//
//  Created by MaraMincho on 8/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct UserInfoResponseDTO: Equatable, Decodable {
  /// 내 아이디
  let id: Int64
  /// 내 이름
  let name: String
  /// 성별 M: 남자, W 여자
  let gender: String?
  /// 출생 년도
  let birth: Int?
}
