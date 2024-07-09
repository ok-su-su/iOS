//
//  MyPageEditProperty.swift
//  MyPage
//
//  Created by MaraMincho on 7/9/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton

// MARK: - GenderSelectButtonItem

struct GenderSelectButtonItem: SingleSelectButtonItemable {
  var id: Int
  var title: String = ""
  var gender: Gender
  init(gender: Gender) {
    self.gender = gender
    id = gender.id
    title = gender.description
  }
}

extension [GenderSelectButtonItem] {
  static var `default`: Self { Gender.allCases.map { .init(gender: $0) } }
}
