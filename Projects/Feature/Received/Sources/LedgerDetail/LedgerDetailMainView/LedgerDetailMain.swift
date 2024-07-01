//
//  LedgerDetailMain.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - LedgerDetailMain

@Reducer
struct LedgerDetailMain {
  @ObservableState
  struct State: Equatable {
    // Detail Main 의 메인 장부 ID
    let ledgerID: Int64
    var ledgerProperty: LedgerDetailProperty
    var isLoading = true
    var isOnAppear = false

    var envelopeItems: [EnvelopeViewForLedgerMainProperty] = [
      .init(id: 0, name: "다함", relationship: "친구", isVisited: true, amount: 6000),
      .init(id: 1, name: "누구", relationship: "친구", isVisited: false, amount: 6000),
      .init(id: 3, name: "다s함", relationship: "친구", isVisited: true, amount: 6000),
      .init(id: 4, name: "누2구", relationship: "친구", isVisited: false, amount: 6000),
    ]

    var header = HeaderViewFeature.State(.init(title: "", type: .depth2DoubleText("편집", "삭제")))
    @Shared var sortProperty: SortHelperProperty
    @Presents var sort: SSSelectableBottomSheetReducer<SortDialItem>.State?

    init(ledgerID: Int64) {
      _sortProperty = .init(.init())
      ledgerProperty = .initial
      self.ledgerID = ledgerID
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
    case tappedSortButton
    case isOnAppear(Bool)
    case tappedFloatingButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .tappedFilterButton:
      return .none
    case .tappedSortButton:
      return .none
    case let .isOnAppear(val):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = val
      return .send(.async(.getLedgerDetailProperty))
    case .tappedFloatingButton:
      // add move Create Envelope View
      return .none
    }
  }

  enum InnerAction: Equatable {
    case updateLedgerDetailProperty(LedgerDetailProperty)
    case updateEnvelopes([EnvelopeViewForLedgerMainProperty])
    case isLoading(Bool)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .updateLedgerDetailProperty(property):
      state.ledgerProperty = property
      return .none
    case let .updateEnvelopes(envelopes):
      state.envelopeItems += envelopes
      return .none
    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  @Dependency(\.ledgerDetailMainNetwork) var network
  enum AsyncAction: Equatable {
    case getLedgerDetailProperty
    case getEnvelopes
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .getLedgerDetailProperty:
      return .run { [id = state.ledgerID] send in
        await send(.inner(.isLoading(true)))
        let ledgerProperty = try await network.getLedgerDetail(ledgerID: id)
        await send(.inner(.updateLedgerDetailProperty(ledgerProperty)))
        await send(.inner(.isLoading(false)))
      }
    case .getEnvelopes:
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none
    }
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
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction

extension LedgerDetailMain: FeatureViewAction, FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction {}
