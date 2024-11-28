//
//  CreateEnvelopeEventProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSNetwork

// MARK: - CategoryModel

public struct CreateEnvelopeEventProperty: Identifiable, Codable, Equatable, Sendable, SingleSelectButtonItemable {
  public var title: String {
    get { name }
    set { name = newValue }
  }

  init(_ categoryModel: CategoryModel) {
    id = categoryModel.id
    seq = categoryModel.seq
    name = categoryModel.name
    style = categoryModel.style
    isActive = categoryModel.isActive
    isCustom = categoryModel.isCustom
    isMiscCategory = categoryModel.isMiscCategory
  }

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
