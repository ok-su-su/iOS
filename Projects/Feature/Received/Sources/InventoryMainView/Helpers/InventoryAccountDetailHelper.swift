//
//  InventoryAccountDetailHelper.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - InventoryAccountDetailHelper

struct InventoryAccountDetailHelper {
  let price: String
  let category: InventoryType
  let accountTitle: String
  let date: Date
  let accountList: [InventoryAccountList]

  var priceText: String {
    return "전체 \(InventoryNumberFormatter.formattedByThreeZero(price) ?? "0")원"
  }

  var accountTitleText: String {
    return accountTitle
  }

  var dateText: String {
    return date.toString(with: "YYYY년 MM월 DD일")
  }
}

// MARK: - InventoryAccountList

struct InventoryAccountList {
  let name: String
  let type: [String]
  let price: String
}

// MARK: - InventoryNumberFormatter

enum InventoryNumberFormatter {
  static let numberFormatter = NumberFormatter()

  static func priceToInt(_ val: String) -> Int? {
    let converted = val.map { String($0) }.compactMap { Int($0) }.map { String($0) }.joined()
    return Int(converted)
  }

  static func formattedByThreeZero(_ val: String) -> String? {
    let val = val.map { String($0) }.compactMap { Int($0) }.map { String($0) }
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(for: Int(val.joined()))
  }
}
