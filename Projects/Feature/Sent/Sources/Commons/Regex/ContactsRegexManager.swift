//
//  ContactsRegexManager.swift
//  Sent
//
//  Created by MaraMincho on 6/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum ContactsRegexManager {
  static func isValid(_ text: String) -> Bool {
    let regex = /^\d{11}$/
    return text.contains(regex)
  }
}
