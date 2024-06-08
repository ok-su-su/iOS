//
//  UserDefaultsManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public final class UserDefaultsManager {
  static var shared = UserDefaultsManager()
  
  private let userDefaults: UserDefaults = .standard
  
  private init() {}
  
  public func setValue(key: String, value: AnyObject) {
    userDefaults.setValue(value, forKey: key)
  }
  
  public func getValue(key: String) -> Any? {
    return userDefaults.value(forKey: key)
  }
  
  public func getValue<T>(key: String) -> T? {
    return userDefaults.value(forKey:key) as? T
  }
}
