//
//  InventoryAccountDetail.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryAccountDetail

@Reducer
public struct InventoryAccountDetail {
  @ObservableState
  public struct State {
    var headerType = HeaderViewFeature.State(.init(title: "", type: .depth2DoubleText("편집", "삭제")))
    var tabbarType = SSTabBarFeature.State(tabbarType: .received)
    var accountProperty: InventoryAccountDetailHelper
    var accountItems: IdentifiedArrayOf<InventoryAccount.State> = [
      .init(accountType: [.family, .unvisited, .visited], accountTitle: "김철수", accountPrice: "10000"),
      .init(accountType: [.family, .visited], accountTitle: "박미영", accountPrice: "70000"),
      .init(accountType: [.family, .unvisited], accountTitle: "서한누리", accountPrice: "100000"),
    ]

    init(accountProperty: InventoryAccountDetailHelper) {
      self.accountProperty = accountProperty
    }
  }

  @CasePathable
  public enum Action: Equatable {
    case setHeaderView(HeaderViewFeature.Action)
    case setTabbarView(SSTabBarFeature.Action)
    case reloadAccountItems(IdentifiedActionOf<InventoryAccount>)
    case didTapFilterButton
  }

  public enum Path {}

  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: \.setHeaderView) {
      HeaderViewFeature()
    }

    Scope(state: \.tabbarType, action: \.setTabbarView) {
      SSTabBarFeature()
    }

    Reduce { _, action in
      switch action {
      case .setHeaderView:
        return .none
      case .setTabbarView:
        return .none
      case .reloadAccountItems:
        return .none
      case .didTapFilterButton:
        return .none
      }
    }.forEach(\.accountItems, action: \.reloadAccountItems) {
      InventoryAccount()
    }
  }
}
