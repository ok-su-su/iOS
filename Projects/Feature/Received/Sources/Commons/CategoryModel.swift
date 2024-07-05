//
//  CategoryModel.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CategoryModel

struct CategoryModel: Codable, Equatable {
  /// 카테고리 아이디
  let id: Int
  /// 카테고리 순서
  let seq: Int
  /// 카테고리 이름
  let name: String
  /// 카테고리 스타일
  let style: String
  /// 기타
  let isMiscCategory: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case name
    case style
    case isMiscCategory
  }
}
