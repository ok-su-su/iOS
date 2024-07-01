// 
//  CreateLedgerCategory.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture
import FeatureAction
import SSSelectableItems
import Designsystem

@Reducer
struct CreateLedgerCategory {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var selectableItems: [CreateLedgerCategoryItem]
    @Shared var selectedItemsID: [Int]
    @Shared var customItems: CreateLedgerCategoryItem?
    var selection: SSSelectableItemsReducer<CreateLedgerCategoryItem>.State
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(0.33)))
    var isLoading = true
    var isPushable: Bool {
      !selectedItemsID.isEmpty
    }
    init () {
      _selectableItems = .init([])
      _selectedItemsID = .init([])
      _customItems = .init(nil)
      selection = .init(items: _selectableItems, selectedID: _selectedItemsID, isCustomItem: _customItems)
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedNextButton
  }

enum InnerAction: Equatable {
  case pushNextScreen
}
  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .pushNextScreen:
      return .none
    }
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case selection( SSSelectableItemsReducer<CreateLedgerCategoryItem>.Action)
    case header(HeaderViewFeature.Action)
  }
  func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {

    case .selection:
      return .none
    case .header(_):
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear) :
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    case .tappedNextButton:
      return .none
    }
  }


  var body: some Reducer<State, Action> {
    Scope(state: \.selection, action: \.scope.selection) {
      SSSelectableItemsReducer()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      }
    }
  }
}
extension CreateLedgerCategory: FeatureScopeAction, FeatureInnerAction {



}

extension Reducer where Self.State == CreateLedgerCategory.State, Self.Action == CreateLedgerCategory.Action { }

struct CreateLedgerCategoryItem: SSSelectableItemable {
  /// 카테고리 이름 입니다.
  var title: String
  /// 카테고리 아이디 입니다.
  var id: Int

  mutating func setTitle(_ val: String) {
    self.title = val
  }
}
