//
//  SSUserDefaultsManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public final class SSUserDefaultsManager: Sendable {
  public static let shared = SSUserDefaultsManager()

  private var userDefaults: UserDefaults { .standard }

  private let jsonDecoder = JSONDecoder()
  private let jsonEncoder = JSONEncoder()

  private init() {}

  public func setValue(key: String, value: Encodable) {
    let data = try? jsonEncoder.encode(value)
    userDefaults.setValue(data, forKey: key)
  }

  public func getValue<T: Decodable>(key: String) -> T? {
    guard let data = userDefaults.value(forKey: key) as? Data else {
      return nil
    }
    return try? jsonDecoder.decode(T.self, from: data)
  }
}
