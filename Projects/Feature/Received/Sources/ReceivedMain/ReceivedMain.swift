//
//  ReceivedMain.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem
import FeatureAction
import SSSearch

@Reducer
struct ReceivedMain {
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = false
    var isOnAppear: Bool = false

    /// ScopeState
    var header = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var floatingState = InventoryFloating.State()
    var tabBar = SSTabBarFeature.State(tabbarType: .received)
    @Presents var search = SSSearchReducer.State(helper: <#T##Shared<SSSearchPropertiable>#>)

    var ledgersProperty: [LedgerBoxProperty] = []
    init() {}
  }

  public init() {}

  @CasePathable
  enum Action: FeatureAction, Equatable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case didTapInventoryView
    case didTapLatestButton
    case didTapFilterButton
    case didTapAddInventoryButton
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case sortSheet(PresentationAction<InventorySortSheet.Action>)
  }

  enum DelegateAction: Equatable {}

   var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case .didTapInventoryView:
      return .none

    case .didTapLatestButton:
      return .none

    case .didTapFilterButton:
      return .none

    case .didTapAddInventoryButton:
      return .none
    }
   }

   var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { state, action in
     switch action {
     case .header(_):
       return .none
     case .tabBar(_):
       return .none
     case .sortSheet(_):
       return .none
     }
   }

  

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
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
