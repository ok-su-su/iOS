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
    var header = HeaderViewFeature.State(.init(title: "", type: .depth2DoubleText("편집", "삭제")))
    var accountProperty: InventoryAccountDetailHelper
    var envelopeItems: [EnvelopeViewForLedgerMainProperty] = [
      .init(id: 0, name: "다함", relationship: "친구", isVisited: true, amount: 6000),
      .init(id: 1, name: "누구", relationship: "친구", isVisited: false, amount: 6000),
      .init(id: 3, name: "다s함", relationship: "친구", isVisited: true, amount: 6000),
      .init(id: 4, name: "누2구", relationship: "친구", isVisited: false, amount: 6000),
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
    Scope(state: \.header, action: \.scope.header) {
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
