//
//  NameRegexManager.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum NameRegexManager {
  static func isValid(name: String) -> Bool {
    let regex = /^[가-힣]{1,10}$/
    return name.contains(regex)
  }
}
