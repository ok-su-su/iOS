//
//  main.swift
//  KeychainWrapper
//
//  Created by 김건우 on 5/13/24.
//

import Foundation

protocol KeychainAttrRepresentable {
  var keychainAttrValue: CFString { get }
}

// MARK: - KeychainItemAccessibility
public enum KeychainItemAccessibility {
  @available(iOS 4, *)
  case afterFirstUnlock
  
  @available(iOS 4, *)
  case afterFirstUnlockThisDeviceOnly
  
  @available(*, deprecated, renamed: "afterFirstUnlock")
  case always
  
  @available(*, deprecated, renamed: "afterFirstUnlockThisDeviceOnly")
  case alwaysThisDeviceOnly
  
  @available(iOS 4, *)
  case whenPasscodeSetThisDeviceOnly
  
  @available(iOS 4, *)
  case whenUnlocked
  
  @available(iOS 4, *)
  case whenUnlockedThisDeviceOnly
  
  static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> KeychainItemAccessibility? {
    for (key, value) in keychainItemAccessibilityLookup {
      if value == keychainAttrValue {
        return key
      }
    }
    
    return nil
  }
}

private let keychainItemAccessibilityLookup: [KeychainItemAccessibility: CFString] = {
  var lookup: [KeychainItemAccessibility: CFString] = [
    .afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock,
    .afterFirstUnlockThisDeviceOnly: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    .always: kSecAttrAccessibleAlways,
    .alwaysThisDeviceOnly: kSecAttrAccessibleAlwaysThisDeviceOnly,
    .whenPasscodeSetThisDeviceOnly: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
    .whenUnlocked: kSecAttrAccessibleWhenUnlocked,
    .whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  ]
  
  return lookup
}()

// MARK: - Extensions
extension KeychainItemAccessibility: KeychainAttrRepresentable {
  internal var keychainAttrValue: CFString {
    return keychainItemAccessibilityLookup[self]!
  }
}

