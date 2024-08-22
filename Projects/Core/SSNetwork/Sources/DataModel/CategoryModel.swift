//
//  CategoryModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CategoryModel

public struct CategoryModel: Codable, Equatable {
  /// 카테고리 아이디
  public let id: Int
  /// 카테고리 순서
  public let seq: Int
  /// 카테고리 이름
  public let name: String
  /// 카테고리 스타일
  public let style: String
  /// 기타
  public let isMiscCategory: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case name
    case style
    case isMiscCategory
  }
}
