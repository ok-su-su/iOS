//
//  TextValidator.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum TextValidator {
  static func checkCategoryName(_ name: String) -> Bool {
    let regex = /^[가-힣a-zA-Z0-9 ]{1,10}$/
    return name.contains(regex)
  }
  static func checkCategoryNameWithToast(_ name: String) -> Bool {
    return name.count >= 10 
  }
}
