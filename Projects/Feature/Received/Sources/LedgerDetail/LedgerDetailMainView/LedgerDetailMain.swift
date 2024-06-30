//
//  LedgerDetailMain.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem
import FeatureAction

// MARK: - LedgerDetailMain

@Reducer
struct LedgerDetailMain {
  @ObservableState
  struct State: Equatable {
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

    init() {
      accountProperty = .init(price: "450", category: .Birthday, accountTitle: "이니셜 없이 들어오누", date: .now, accountList: [])
    }
  }

  @CasePathable
  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case tappedFilterButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureScopeAction

extension LedgerDetailMain: FeatureViewAction, FeatureScopeAction {
  func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none
    }
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    state
    switch action {
    case .tappedFilterButton:
      return .none
    }
  }
}
