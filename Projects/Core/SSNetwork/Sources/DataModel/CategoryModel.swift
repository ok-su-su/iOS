//
//  CategoryModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CategoryModel

public struct CategoryModel: Identifiable, Codable, Equatable, Sendable {
  /// 카테고리 아이디
  public let id: Int
  /// 카테고리 순서
  public let seq: Int
  /// 카테고리 이름
  public var name: String
  /// 카테고리 스타일
  public let style: String
  /// 활성화 여부
  public let isActive: Bool
  /// 커스텀 여부
  public let isCustom: Bool
  /// 기타
  public let isMiscCategory: Bool

  enum CodingKeys: CodingKey {
    case id
    case seq
    case name
    case style
    case isActive
    case isCustom
    case isMiscCategory
  }

  public init(id: Int, seq: Int, name: String, style: String, isActive: Bool, isCustom: Bool, isMiscCategory: Bool) {
    self.id = id
    self.seq = seq
    self.name = name
    self.style = style
    self.isActive = isActive
    self.isCustom = isCustom
    self.isMiscCategory = isMiscCategory
  }
}

public extension [CategoryModel] {
  static var fakeData: [CategoryModel] {
    return [
      CategoryModel(id: 1, seq: 1, name: "결혼식", style: "Orange60", isActive: true, isCustom: false, isMiscCategory: false),
      CategoryModel(id: 2, seq: 2, name: "돌잔치", style: "Orange60", isActive: true, isCustom: false, isMiscCategory: false),
      CategoryModel(id: 3, seq: 3, name: "장례식", style: "Gray90", isActive: true, isCustom: false, isMiscCategory: false),
      CategoryModel(id: 4, seq: 4, name: "생일 기념일", style: "Blue60", isActive: true, isCustom: false, isMiscCategory: false),
      CategoryModel(id: 5, seq: 5, name: "기타", style: "Gray40", isActive: true, isCustom: true, isMiscCategory: true),
      CategoryModel(id: 6, seq: 6, name: "개업", style: "Green60", isActive: true, isCustom: false, isMiscCategory: false),
      CategoryModel(id: 7, seq: 7, name: "명절", style: "Red60", isActive: true, isCustom: false, isMiscCategory: false),
    ]
  }
}
