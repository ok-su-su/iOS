//
//  SharedContainer.swift
//  Sent
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

/// Do not use this display of view parts.
/// Because this is not mutable function, so view will not render.
final class SharedContainer {
  private init() {}
  private nonisolated(unsafe) static var shared = SharedContainer()
  private var cache: [String: Any] = [:]

  /// Save value at memory
  /// - Parameter value: Class type obejct
  static func setValue<T>(_ value: T) {
    shared.cache[String(describing: T.self)] = value
  }

  static func deleteValue<T>(_: T) {
    shared.cache.removeValue(forKey: String(describing: T.self))
  }

  static func setValue(key: String, _ value: Any) {
    shared.cache[key] = value
  }

  /// Get value from memory cache
  /// - Parameter value: class Type Object
  static func getValue<T>(_: T.Type) -> T? {
    shared.cache[String(describing: T.self)] as? T
  }

  static func getValue<T>(key: String) -> T? {
    shared.cache[key] as? T
  }
}
