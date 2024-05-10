//
//  InventoryBox.swift
//  SSRoot
//
//  Created by Kim dohyun on 5/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct InventoryBox {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: UUID = .init()
    public var inventoryType: InventoryType
    public var inventoryTitle: String
    public var inventoryAmount: String
    public var inventoryCount: Int

    public init(inventoryType: InventoryType, inventoryTitle: String, inventoryAmount: String, inventoryCount: Int) {
      self.inventoryType = inventoryType
      self.inventoryTitle = inventoryTitle
      self.inventoryAmount = inventoryAmount
      self.inventoryCount = inventoryCount
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {}
    }
  }
}
