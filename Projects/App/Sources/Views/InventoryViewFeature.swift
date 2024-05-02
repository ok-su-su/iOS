//
//  InventoryViewFeature.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import OSLog

// MARK: - InventoryCellFeature

@Reducer
public struct InventoryCellFeature {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: UUID
    public var inventoryType: String
    public var inventoryTitle: String
    public var inventoryAmount: String
    public var inventoryCount: Int

    public init(id: UUID, inventoryType: String, inventoryTitle: String, inventoryAmount: String, inventoryCount: Int) {
      self.id = id
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

// MARK: - InventoryViewFeature

@Reducer
public struct InventoryViewFeature: Equatable {
  @ObservableState
  public struct State {
    public var inventorys: IdentifiedArrayOf<InventoryCellFeature.State>
    public var isLoading: Bool

    init(inventorys: IdentifiedArrayOf<InventoryCellFeature.State>, isLoading: Bool = false) {
      self.inventorys = inventorys
      self.isLoading = isLoading
    }
  }

  public enum Action {
    case reloadInvetoryItems(IdentifiedActionOf<InventoryCellFeature>)
    case didTapLatestButton
    case didTapFilterButton
    case didTapAddInventoryButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .reloadInvetoryItems:
        state.isLoading.toggle()
        return .none
      case .didTapLatestButton:
        return .none
      case .didTapFilterButton:
        return .none
      case .didTapAddInventoryButton:
        os_log("Inventory button Tap")
        return .none
      }
    }
  }
}
