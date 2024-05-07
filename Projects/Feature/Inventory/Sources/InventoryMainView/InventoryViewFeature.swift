//
//  InventoryViewFeature.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Designsystem
import ComposableArchitecture
import OSLog

@Reducer
public struct InventoryViewFeature: Equatable {
  
  public init() {}
  
  @ObservableState
  public struct State {
    var inventorys: IdentifiedArrayOf<InventoryBox.State>
    var isLoading: Bool
    var headerType = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabbarType = SSTabBarFeature.State(tabbarType: .inventory)
    public init(inventorys: IdentifiedArrayOf<InventoryBox.State>, isLoading: Bool = false) {
      self.inventorys = inventorys
      self.isLoading = isLoading
    }
  }
  
  public enum Action {
    case setHeaderView(HeaderViewFeature.Action)
    case setTabbarView(SSTabBarFeature.Action)
    case setFloatingView(InventoryFloating.Action)
    case reloadInvetoryItems(IdentifiedActionOf<InventoryBox>)
    case didTapLatestButton
    case didTapFilterButton
    case didTapAddInventoryButton
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: /Action.setHeaderView) {
      HeaderViewFeature()
    }
    
    Scope(state: \.tabbarType, action: /Action.setTabbarView) {
      SSTabBarFeature()
    }
    
    Scope(state: \.floatingState, action: /Action.setFloatingView) {
        InventoryFloating()
    }
    
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
      default:
        return .none
      }
    }.forEach(\.inventorys, action: \.reloadInvetoryItems) {
        InventoryBox()
    }
  }
}