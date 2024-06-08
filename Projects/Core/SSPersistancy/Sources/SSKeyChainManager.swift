//
//  SSKeyChainManager.swift
//  SSPersistancy
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - Keychaining

public protocol Keychaining {
  /// 키체인에 키-data로 데이터를 저장합니다.
  @discardableResult
  func save(key: String, data: Data) -> OSStatus

  /// 키체인에서 키를 통해 data 값을 얻어옵니다.
  func load(key: String) -> Data?

  /// 키체인에서 해당하는 키를 삭제합니다.
  @discardableResult
  func delete(key: String) -> OSStatus
}

// MARK: - SSKeychain

public final class SSKeychain: Keychaining {
  public static let shared = SSKeychain()

  private init() {}

  @discardableResult
  public func save(key: String, data: Data) -> OSStatus {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data,
    ]

    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }

  public func load(key: String) -> Data? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: kCFBooleanTrue!,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == noErr else {
      return nil
    }

    return item as? Data
  }

  @discardableResult
  public func delete(key: String) -> OSStatus {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
    ]

    return SecItemDelete(query as CFDictionary)
  }
}
