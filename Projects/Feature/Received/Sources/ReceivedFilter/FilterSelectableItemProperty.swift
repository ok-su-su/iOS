//
//  FilterSelectableItemProperty.swift
//  Received
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSFilter
import SSNetwork

// MARK: - FilterSelectableItemProperty

/// CategoryModel과 동일한 구조입니다. 만약 CategoryModel이 바뀔 경우에는 필수적으로 다음과 같은 파일을 수정해야 합니다.
struct FilterSelectableItemProperty: SSFilterItemable {
  /// 카테고리 아이디
  public let id: Int64
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

  public init(id: Int64, seq: Int, name: String, style: String, isActive: Bool, isCustom: Bool, isMiscCategory: Bool) {
    self.id = id
    self.seq = seq
    self.name = name
    self.style = style
    self.isActive = isActive
    self.isCustom = isCustom
    self.isMiscCategory = isMiscCategory
  }

  public var title: String {
    get { name }
    set { name = newValue }
  }
}
