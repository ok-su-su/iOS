//
//  InventoryAccount.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - AccountType

enum AccountType: String, CaseIterable {
  case family = "가족"
  case unvisited = "미방문"
  case visited = "방문"
  case friend = "친구"
}

// MARK: - InventoryAccount

@Reducer
public struct InventoryAccount {
  @ObservableState
  public struct State: Identifiable {
    public var id = UUID()
    var accountType: [AccountType]
    var accountTitle: String
    var accountPrice: String

    var accountPriceText: String {
      return "\(InventoryNumberFormatter.formattedByThreeZero(accountPrice) ?? "0") 원"
    }

    var accountBadgeColors: [SmallBadgeProperty.BadgeColor] {
      return [.orange60, .blue60, .gray90]
    }
  }

  public enum Action: Equatable {}

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
