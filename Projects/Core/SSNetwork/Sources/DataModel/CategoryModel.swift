//
//  CategoryModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CategoryModel

public struct CategoryModel: Identifiable, Codable, Equatable {
  /// 카테고리 아이디
  public let id: Int
  /// 카테고리 순서
  public let seq: Int
  /// 카테고리 이름
  public var name: String
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

  public init(id: Int, seq: Int, name: String, style: String, isMiscCategory: Bool) {
    self.id = id
    self.seq = seq
    self.name = name
    self.style = style
    self.isMiscCategory = isMiscCategory
  }
}
