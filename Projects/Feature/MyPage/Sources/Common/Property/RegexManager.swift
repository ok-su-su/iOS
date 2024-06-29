//
//  RegexManager.swift
//  MyPage
//
//  Created by MaraMincho on 6/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum RegexManager {
  static func isValidName(_ name: String) -> Bool {
    let regex = /^[가-힣| ]{1,10}$/
    return name.contains(regex)
  }
}
