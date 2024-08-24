//
//  BoardModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct BoardModel: Equatable, Codable {
  /// 카테고리 아이디
  public let id: Int64
  /// 카테고리 이름
  public let name: String
  /// 보드 순서
  public let seq: Int32
  /// 활성화 여부 / 활성화: 1, 비 활성화: 0
  public let isActive: Bool
}
