//
//  ToastRegexManager.swift
//  SSRegexManager
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum ToastRegexManager {
  public static func isShowToastByName(_ name: String) -> Bool {
    return name.count > 10
  }

  public static func isShowToastByPrice(_ value: String) -> Bool {
    return value.count > 10
  }

  public static func isShowToastByCustomRelationShip(_ value: String) -> Bool {
    return value.count > 10
  }

  public static func isShowToastByCustomCategory(_ value: String) -> Bool {
    return value.count > 10
  }

  public static func isShowToastByLedgerName(_ name: String) -> Bool {
    return name.count > 10
  }

  public static func isShowToastByGift(_ value: String) -> Bool {
    return value.count > 30
  }

  public static func isShowToastByMemo(_ value: String) -> Bool {
    return value.count > 30
  }

  public static func isShowToastByContacts(_ value: String) -> Bool {
    return value.count > 11
  }
}
