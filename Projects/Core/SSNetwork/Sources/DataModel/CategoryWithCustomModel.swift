//
//  CategoryWithCustomModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchEnvelopeResponseCategoryDTO

public struct CategoryWithCustomModel: Codable, Equatable {
  /// 카테고리 아이디
  public let id: Int
  ///
  public let seq: Int
  /// 카테고리 이름
  public let category: String
  /// 커스텀 카테고리면 not nill
  public let customCategory: String?
  /// 색깔을 나타내는 property입니다.
  public let style: String

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case category
    case customCategory
    case style
  }
}
