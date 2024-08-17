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
import SSAlert
import SSBottomSelectSheet
import SSCreateEnvelope

// MARK: - LedgerDetailMain

@Reducer
struct LedgerDetailMain {
  @ObservableState
  struct State: Equatable {
    // Detail Main 의 메인 장부 ID
    var ledgerID: Int64
    var ledgerProperty: LedgerDetailProperty
    var isLoading = true
    var isRefresh = false
    var isOnAppear = false
    var presentCreateEnvelope = false

    var createEnvelopeProperty: CreateEnvelopeRequestBody = .init(type: .received)

    /// 무한 스크롤을 위해 사용되는 Property
    var page = 0
    var isEndOfPage = false

    fileprivate var isUpdateLedgerDetail: Bool = false
    /// EnvelopeItems
    var envelopeItems: [EnvelopeViewForLedgerMainProperty] = []

    var header = HeaderViewFeature.State(.init(title: "", type: .depth2DoubleText("편집", "삭제")))
    @Shared var sortProperty: SortHelperForLedgerEnvelope
    @Presents var sort: SSSelectableBottomSheetReducer<SortDialItemForLedgerEnvelopeItem>.State?
    var showMessageAlert = false

    @Shared var filterProperty: LedgerDetailFilterProperty
    @Presents var filter: LedgerDetailFilter.State?

    var isFilteredItem: Bool {
      !filterProperty.selectedItems.isEmpty ||
        !(filterProperty.amountFilterBadgeText == nil)
    }

    init(ledgerID: Int64) {
      _sortProperty = .init(.init())
      ledgerProperty = .initial
      self.ledgerID = ledgerID
      _filterProperty = .init(.init())
    }
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.updateLedgerDetailPublisher) var updateLedgerPublisher
  @Dependency(\.receivedMainUpdatePublisher) var receivedMainUpdatePublisher

  @CasePathable
  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case tappedFilterButton
    case tappedSortButton
    case isOnAppear(Bool)
    case tappedFloatingButton
    case dismissCreateEnvelope(Data)
    case showAlert(Bool)
    case tappedDeleteLedgerButton
    case tappedFilteredAmountButton
    case tappedFilteredPersonButton(id: Int64)
    case appearedEnvelope(EnvelopeViewForLedgerMainProperty)
    case tappedEnvelope(id: Int64)
    case pullRefreshButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .tappedFilterButton:
      state.filter = .init(state.$filterProperty)
      return .none

    case .tappedSortButton:
      state.sort = .init(
        items: state.sortProperty.defaultItems,
        selectedItem: state.$sortProperty.selectedFilterDial
      )
      return .none

    case let .isOnAppear(val):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = val
      return .concatenate(
        .send(.async(.getLedgerDetailProperty)),
        .send(.inner(.getEnvelopesInitialPage)),
        sinkPublisher()
      )

    case .tappedFloatingButton:
      state.createEnvelopeProperty = CreateEnvelopeRequestBody(
        type: "RECEIVED",
        ledgerID: state.ledgerID,
        category: .init(id: state.ledgerProperty.categoryID, customCategory: state.ledgerProperty.customCategory)
      )
      state.presentCreateEnvelope = true
      return .none

    case let .dismissCreateEnvelope(data):
      guard let dto = try? JSONDecoder().decode(CreateAndUpdateEnvelopeResponse.self, from: data) else {
        return .none
      }
      let property = EnvelopeViewForLedgerMainProperty(
        id: dto.envelope.id,
        name: dto.friend.name,
        relationship: dto.relationship.relation,
        isVisited: dto.envelope.hasVisited,
        gift: dto.envelope.gift,
        amount: dto.envelope.amount
      )
      state.envelopeItems.insert(property, at: 0)
      return .send(.async(.getLedgerDetailProperty))

    case let .showAlert(val):
      state.showMessageAlert = val
      return .none

    // 장부 삭제 플로우
    case .tappedDeleteLedgerButton:
      let id = state.ledgerID
      return .run { send in
        await send(.inner(.isLoading(true)))
        try await network.deleteLedger(id: id)
        await send(.inner(.isLoading(false)))
        receivedMainUpdatePublisher.deleteLedger(ledgerID: id)
        await dismiss()
      }

    case .tappedFilteredAmountButton:
      state.filterProperty.resetAmountFilter()
      return .send(.inner(.getEnvelopesInitialPage))

    case let .tappedFilteredPersonButton(id: id):
      state.filterProperty.select(id)
      return .send(.inner(.getEnvelopesInitialPage))

    case let .appearedEnvelope(envelope):
      if envelope.id == state.envelopeItems.last?.id {
        return .send(.inner(.getEnvelopesNextPage))
      }
      return .none

    case let .tappedEnvelope(id):
      LedgerDetailRouterPublisher.send(.envelopeDetail(.init(envelopeID: id)))
      return .none

    case .pullRefreshButton:
      return .concatenate(
        .send(.inner(.isRefresh(true))),
        .send(.async(.getLedgerDetailProperty)),
        .send(.inner(.getEnvelopesInitialPage)),
        .send(.inner(.isRefresh(false)))
      )
    }
  }

  enum InnerAction: Equatable {
    case updateLedgerDetailPropertyByLedgerID(Int64)
    case updateLedgerDetailProperty(LedgerDetailProperty)
    case updateEnvelopes([EnvelopeViewForLedgerMainProperty])
    case overwriteEnvelopes([EnvelopeViewForLedgerMainProperty])
    case isLoading(Bool)
    case getEnvelopesInitialPage
    case getEnvelopesNextPage
    case deleteEnvelope(id: Int64)
    case isRefresh(Bool)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .updateLedgerDetailProperty(property):
      state.ledgerProperty = property
      SharedContainer.setValue(state.ledgerProperty)
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

    case let .overwriteEnvelopes(val):
      val.forEach { property in
        if let firstIndex = state.envelopeItems.firstIndex(where: { $0.id == property.id }) {
          state.envelopeItems[firstIndex] = property
        }
      }
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case .getEnvelopesInitialPage:
      state.page = 0
      state.envelopeItems.removeAll()
      state.isEndOfPage = false
      return .send(.async(.getEnvelopes))

    case .getEnvelopesNextPage:
      return state.isEndOfPage ? .none : .send(.async(.getEnvelopes))

    case let .deleteEnvelope(id):
      state.envelopeItems.removeAll(where: { $0.id == id })
      return .none

    case let .updateLedgerDetailPropertyByLedgerID(ledgerID):
      state.ledgerID = ledgerID
      return .send(.async(.getLedgerDetailProperty))

    case let .isRefresh(val):
      state.isRefresh = val
      return .none
    }
  }

  @Dependency(\.ledgerDetailMainNetwork) var network
  enum AsyncAction: Equatable {
    case getLedgerDetailProperty
    case getEnvelopes
    case updateEnvelope(Int64)
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .getLedgerDetailProperty:
      return .run { [id = state.ledgerID] send in
        await send(.inner(.isLoading(true)))
        let ledgerProperty = try await network.getLedgerDetail(ledgerID: id)
        await send(.inner(.updateLedgerDetailProperty(ledgerProperty)))
        await send(.inner(.isLoading(false)))
      }

    case .getEnvelopes:
      let parameter = GetEnvelopesRequestParameter(
        friendIds: state.filterProperty.selectedItems.map(\.id),
        ledgerId: state.ledgerID,
        fromAmount: state.filterProperty.lowestAmount,
        toAmount: state.filterProperty.highestAmount,
        page: state.page,
        sort: state.sortProperty.selectedFilterDial?.sortString ?? ""
      )
      state.page += 1

      return .run { send in
        await send(.inner(.isLoading(true)))
        let envelopes = try await network.getEnvelopes(parameter)
        await send(.inner(.updateEnvelopes(envelopes)))
        await send(.inner(.isLoading(false)))
      }
    case let .updateEnvelope(envelopeID):
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case presentCreateEnvelope(Bool)
    case filter(PresentationAction<LedgerDetailFilter.Action>)
    case sort(PresentationAction<SSSelectableBottomSheetReducer<SortDialItemForLedgerEnvelopeItem>.Action>)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    // 편집 버튼
    case .header(.tappedDoubleTextButton(.leading)):
      let ledgerProperty = state.ledgerProperty
      return .run { _ in
        let category = try await network.getCategories()
        let categoryEditProperty = category.map { CategoryEditProperty(id: $0.id, title: $0.name) }
        let editState = LedgerDetailEdit.State(
          ledgerProperty: ledgerProperty,
          ledgerDetailEditProperty: .init(ledgerDetailProperty: ledgerProperty, category: categoryEditProperty)
        )

        LedgerDetailRouterPublisher.send(.edit(editState))
      }

    case .header(.tappedDoubleTextButton(.trailing)):
      state.showMessageAlert = true
      return .none

    case .header(.tappedDismissButton):
      if state.isUpdateLedgerDetail {
        let ledgerID = state.ledgerID
        receivedMainUpdatePublisher.editLedger(ledgerID: ledgerID)
      }
      return .none
    case .header:

      return .none

    case let .presentCreateEnvelope(present):
      state.presentCreateEnvelope = present
      return .none

    case .filter(.presented(.view(.tappedConfirmButton))):
      return .send(.inner(.getEnvelopesInitialPage))

    case .filter:
      return .none

    case .sort(.presented(.tapped)):
      return .send(.inner(.getEnvelopesInitialPage))

    case .sort:
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
    .addFeatures()
  }
}

// MARK: FeatureViewAction, FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction

extension LedgerDetailMain: FeatureViewAction, FeatureScopeAction, FeatureInnerAction, FeatureAsyncAction {
  func sinkPublisher() -> Effect<Action> {
    .merge(
      .publisher {
        updateLedgerPublisher
          .updateLedgerDetailPublisher
          .map { _ in return .async(.getLedgerDetailProperty) }
      },
      .publisher {
        updateLedgerPublisher
          .updateEnvelopesPublisher
          .map { _ in return .async(.getEnvelopes) }
      },
      .publisher {
        updateLedgerPublisher
          .updateEnvelopePublisher
          .map { _ in .inner(.getEnvelopesInitialPage) }
      }
    )
  }
}

extension Reducer where State == LedgerDetailMain.State, Action == LedgerDetailMain.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$filter, action: \.scope.filter) {
      LedgerDetailFilter()
    }
    .ifLet(\.$sort, action: \.scope.sort) {
      SSSelectableBottomSheetReducer()
    }
  }
}
