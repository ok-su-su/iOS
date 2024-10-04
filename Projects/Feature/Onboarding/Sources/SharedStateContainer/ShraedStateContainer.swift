//
//  ShraedStateContainer.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

/// Do not use this display of view parts.
/// Because this is not mutable function, so view will not render.
final class SharedStateContainer {
  private init() {}
  private nonisolated(unsafe) static var shared = SharedStateContainer()
  private let cache: NSCache<NSString, AnyObject> = .init()

  /// Save value at memory
  /// - Parameter value: Class type obejct
  static func setValue<T: AnyObject>(_ value: T) {
    shared.cache.setObject(value, forKey: String(describing: T.self) as NSString)
  }

  /// Get value from memory cache
  /// - Parameter value: class Type Object
  ///
  /// let value = SharedStateContainer.getValue(MyClass.self)
  static func getValue<T: AnyObject>(_: T.Type) -> T? {
    shared.cache.object(forKey: String(describing: T.self) as NSString) as? T
  }
}
