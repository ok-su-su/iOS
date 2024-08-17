//
//  ReceivedMain.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSBottomSelectSheet
import SSNotification

// MARK: - ReceivedMain

@Reducer
struct ReceivedMain {
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = true
    var isRefresh = false
    var isOnAppear: Bool = false
    var page = 0
    var isEndOfPage = false

    /// ScopeState
    var header = HeaderViewFeature.State(.init(title: "받아요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .received)
    @Shared var sortProperty: SortHelperProperty
    @Shared var filterProperty: FilterHelperProperty
    @Presents var search: ReceivedSearch.State?
    @Presents var sort: SSSelectableBottomSheetReducer<SortDialItem>.State?
    @Presents var filter: ReceivedFilter.State?
    @Presents var detail: LedgerDetailRouter.State?
    @Presents var createLedger: CreateLedgerRouter.State?

    var ledgersProperty: [LedgerBoxProperty] = []

    var isFilteredItem: Bool {
      if (!filterProperty.selectedLedgers.isEmpty) ||
        (filterProperty.selectedFilterDateTextString != nil) {
        return true
      }
      return false
    }

    init() {
      _sortProperty = .init(.init())
      _filterProperty = .init(.init())
    }
  }

  public init() {}

  @Dependency(\.receivedMainNetwork) var network
  @Dependency(\.receivedMainUpdatePublisher) var receivedMainUpdatePublisher

  @CasePathable
  enum Action: FeatureAction, Equatable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case tappedAddLedgerButton
    case tappedFilterButton
    case tappedFilteredDateButton
    case tappedFilteredPersonButton(id: Int)
    case onAppear(Bool)
    case onAppearedLedger(LedgerBoxProperty)
    case tappedSortButton
    case tappedFloatingButton
    case tappedLedgerBox(LedgerBoxProperty)
    case pullRefreshButton
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
    case updateLedgers([LedgerBoxProperty])
    case overwriteLedgers([LedgerBoxProperty])
    case isRefresh(Bool)
    case deleteLedger(Int64)
  }

  enum AsyncAction: Equatable {
    case getLedgersInitialPage
    case getLedgers
    case ledgersNetworkTask
    case updateLedger(Int64)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case search(PresentationAction<ReceivedSearch.Action>)
    case sort(PresentationAction<SSSelectableBottomSheetReducer<SortDialItem>.Action>)
    case filter(PresentationAction<ReceivedFilter.Action>)
    case detail(PresentationAction<LedgerDetailRouter.Action>)
    case createLedger(PresentationAction<CreateLedgerRouter.Action>)
  }

  enum DelegateAction: Equatable {}

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear

      return .merge(
        .send(.async(.getLedgersInitialPage)),
        sinkPublisher()
      )

    case .tappedAddLedgerButton:
      state.createLedger = .init()
      return .none

    case .tappedFilteredDateButton:
      state.filterProperty.resetDate()
      return .none

    case .tappedFilterButton:
      state.filter = .init(state.$filterProperty)
      return .none

    case let .tappedFilteredPersonButton(id: id):
      state.filterProperty.deleteSelectedItem(id: id)
      return .send(.async(.getLedgersInitialPage))

    case .tappedSortButton:
      state.sort = .init(items: state.sortProperty.defaultItems, selectedItem: state.$sortProperty.selectedFilterDial)
      return .none

    case .tappedFloatingButton:
      state.createLedger = .init()
      return .none

    case let .onAppearedLedger(property):
      if state.ledgersProperty.last?.id == property.id {
        return .send(.async(.getLedgers))
      }
      return .none

    case let .tappedLedgerBox(property):
      state.detail = .init(.init(ledgerID: property.id))
      return .none

    case .pullRefreshButton:
      return .concatenate(
        .send(.inner(.isRefresh(true))),
        .send(.async(.getLedgersInitialPage)),
        .send(.inner(.isRefresh(false)))
      )
    }
  }

  var scopeAction: (_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> = { state, action in
    switch action {
    case .header(.tappedSearchButton):
      state.search = .init()
      return .none

    case .header:
      return .none

    case .tabBar:
      return .none

    case .search:
      return .none

    case .sort(.presented(.changedItem)):
      return .send(.async(.getLedgersInitialPage))

    case .sort:
      return .none

    case .filter(.presented(.view(.tappedConfirmButton))):
      return .send(.async(.getLedgersInitialPage))

    case .filter:
      return .none

    case .detail:
      return .none

    case .createLedger:
      return .none
    }
  }

  var innerAction: (_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> = { state, action in
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateLedgers(val):
      let prevCount = state.ledgersProperty.count
      let currentProperty = (state.ledgersProperty + val).uniqued()
      if prevCount == currentProperty.count {
        state.isEndOfPage = true
      }
      state.page += 1
      state.ledgersProperty = currentProperty
      return .none

    case let .isRefresh(val):
      state.isRefresh = val
      return .none

    case let .deleteLedger(ledgerID):
      state.ledgersProperty.removeAll(where: { $0.id == ledgerID })
      return .none

    case let .overwriteLedgers(ledgers):
      ledgers.forEach { property in
        if let firstIndex = state.ledgersProperty.firstIndex(where: { $0.id == property.id }) {
          state.ledgersProperty[firstIndex] = property
        }
      }
      return .none
    }
  }

  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getLedgersInitialPage:
      state.ledgersProperty = []
      state.page = 0
      state.isEndOfPage = false

      return .send(.async(.ledgersNetworkTask))

    case .getLedgers:
      if state.isEndOfPage {
        return .none
      }
      return .send(.async(.ledgersNetworkTask))

    case .ledgersNetworkTask:
      let param = SearchLedgersRequestParameter(
        title: nil,
        categoryIds: state.filterProperty.selectedLedgers.map(\.id),
        fromStartAt: state.filterProperty.isInitialStateOfStartDate ? nil : state.filterProperty.startDate,
        toStartAt: state.filterProperty.isInitialStateOfEndDate ? nil : state.filterProperty.endDate,
        page: state.page,
        sort: state.sortProperty.selectedFilterDial ?? .latest
      )
      return .run { send in
        await send(.inner(.isLoading(true)))
        let property = try await network.getLedgers(param)
        await send(.inner(.updateLedgers(property)))
        await send(.inner(.isLoading(false)))
      }

    case let .updateLedger(id):
      return .run { send in
        let ledgerProperty = try await network.getLedger(id: id)
        await send(.inner(.overwriteLedgers([ledgerProperty])))
      }
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
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      }
    }
    .addFeatures()
  }
}

extension ReceivedMain {
  private func sinkPublisher() -> Effect<Action> {
    return .merge(
      .publisher {
        receivedMainUpdatePublisher
          .deleteLedgerPublisher
          .map { ledgerID in return .inner(.deleteLedger(ledgerID)) }
      },
      .publisher {
        receivedMainUpdatePublisher
          .updateLedgerPublisher
          .map { ledgerID in return .async(.updateLedger(ledgerID)) }
      },
      .publisher {
        receivedMainUpdatePublisher
          .updatePublisher
          .map { _ in return .async(.getLedgersInitialPage) }
      }
    )
  }
}

extension Reducer where State == ReceivedMain.State, Action == ReceivedMain.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$search, action: \.scope.search) {
      ReceivedSearch()
    }
    .ifLet(\.$sort, action: \.scope.sort) {
      SSSelectableBottomSheetReducer()
    }
    .ifLet(\.$filter, action: \.scope.filter) {
      ReceivedFilter()
    }
    .ifLet(\.$detail, action: \.scope.detail) {
      LedgerDetailRouter()
    }
    .addFeatures2()
  }

  private func addFeatures2() -> some ReducerOf<Self> {
    ifLet(\.$createLedger, action: \.scope.createLedger) {
      CreateLedgerRouter()
    }
  }
}
