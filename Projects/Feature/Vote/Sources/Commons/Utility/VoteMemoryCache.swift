//
//  VoteMemoryCache.swift
//  Vote
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum VoteMemoryCache {
  private nonisolated(unsafe) static var memoryCache: [String: Any] = [:]

  static func save(key: String, value: Any) {
    memoryCache[key] = value
  }

  static func value<T>(key: String) -> T? {
    return memoryCache[key] as? T
  }

  static func value<T>() -> T? {
    return memoryCache[String(describing: T.self)] as? T
  }

  static func save<T>(value: T) {
    memoryCache[String(describing: T.self)] = value
  }

  static func getValueAndDelete<T>(key: String) -> T? {
    let resValue = memoryCache[key] as? T
    memoryCache.removeValue(forKey: key)
    return resValue
  }
}
