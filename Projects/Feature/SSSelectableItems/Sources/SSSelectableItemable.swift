//
//  SSSelectableItemable.swift
//  SSSelectableItems
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public protocol SSSelectableItemable: Identifiable, Equatable {
  var title: String { get }
  var id: Int { get }

  /// 커스텀 아이템의 Title을 변경할 때 사용합니다.
  mutating func setTitle(_ val: String)
}
