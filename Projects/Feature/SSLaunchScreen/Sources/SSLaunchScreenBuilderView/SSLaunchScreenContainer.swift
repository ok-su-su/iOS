//
//  SSLaunchScreenContainer.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class LaunchScreenContainer {
  static var shared: LaunchScreenContainer = .init()
  
  var container: [String: Any] = [:]
  private init() {}
  
  func register<T>(_ object: T) {
    let key = String(describing: T.self)
    container[key] = object
  }
  
  func value<T>() -> T? {
    let key = String(describing: T.self)
    return container[key] as? T
  }
}
