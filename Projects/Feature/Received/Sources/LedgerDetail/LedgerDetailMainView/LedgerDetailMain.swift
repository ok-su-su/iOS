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
import SSCreateEnvelope

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
    var presentCreateEnvelope = false

    /// 무한 스크롤을 위해 사용되는 Property
    var page = 0
    var isEndOfPage = false

    var envelopeItems: [EnvelopeViewForLedgerMainProperty] = []

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
      return .concatenate(
        .send(.async(.getLedgerDetailProperty)),
        .send(.inner(.getEnvelopesNextPage))
      )

    case .tappedFloatingButton:
      state.presentCreateEnvelope = true
      return .none
    }
  }

  enum InnerAction: Equatable {
    case updateLedgerDetailProperty(LedgerDetailProperty)
    case updateEnvelopes([EnvelopeViewForLedgerMainProperty])
    case isLoading(Bool)
    case getEnvelopesInitialPage
    case getEnvelopesNextPage
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .updateLedgerDetailProperty(property):
      state.ledgerProperty = property
      return .none

    case let .updateEnvelopes(envelopes):
      let currentItemCount = state.envelopeItems.count
      let willUpdateItem = (state.envelopeItems + envelopes).uniqued()
      if willUpdateItem.count == currentItemCount ||
        envelopes.count != GetEnvelopesRequestParameter.defaultSize {
        state.isEndOfPage = true
      }
      state.envelopeItems = willUpdateItem
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case .getEnvelopesInitialPage:
      state.page = 0
      state.envelopeItems.removeAll()
      state.isEndOfPage = false
      return .none

    case .getEnvelopesNextPage:
      return state.isEndOfPage ? .none : .send(.async(.getEnvelopes))
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
      // TODO: Filter에 맞게 param 수정 필요
      let parameter = GetEnvelopesRequestParameter(ledgerId: state.ledgerID)
      return .run { send in
        await send(.inner(.isLoading(true)))
        let envelopes = try await network.getEnvelopes(parameter)
        await send(.inner(.updateEnvelopes(envelopes)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case presentCreateEnvelope(Bool)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none
    case let .presentCreateEnvelope(present):
      state.presentCreateEnvelope = present
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
