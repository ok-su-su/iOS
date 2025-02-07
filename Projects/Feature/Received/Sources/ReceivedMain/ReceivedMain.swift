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
import SwiftAsyncMutex

// MARK: - ReceivedMain

@Reducer
struct ReceivedMain: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
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
    @Presents var presentDestination: ReceivedMainPresentationDestination.State?

    var ledgersProperty: [LedgerBoxProperty] = []

    var mutexManager = AsyncMutexManager()

    var isFilteredItem: Bool {
      if (!filterProperty.selectedCategories.isEmpty) ||
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
  enum Action: FeatureAction, Equatable, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case tappedAddLedgerButton
    case tappedFilterButton
    case tappedFilteredDateButton
    case tappedFilteredPersonButton(id: FilterSelectableItemProperty.ID)
    case onAppear(Bool)
    case onAppearedLedger(LedgerBoxProperty)
    case tappedSortButton
    case tappedFloatingButton
    case tappedLedgerBox(LedgerBoxProperty)
    case pullRefreshButton
  }

  enum InnerAction: Equatable, Sendable {
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
  enum ScopeAction: Equatable, Sendable {
    case presentDestination(PresentationAction<ReceivedMainPresentationDestination.Action>)
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
  }

  enum DelegateAction: Equatable, Sendable {}

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
      state.presentDestination = .createLedger(.init())
      return .none

    case .tappedFilteredDateButton:
      state.filterProperty.resetDate()
      return .send(.async(.getLedgersInitialPage))

    case .tappedFilterButton:
      state.presentDestination = .filter(.init(state.$filterProperty))
      return .none

    case let .tappedFilteredPersonButton(id: id):
      state.filterProperty.deleteSelectedItem(id: id)
      return .send(.async(.getLedgersInitialPage))

    case .tappedSortButton:
      state.presentDestination =
        .sort(
          .init(
            items: state.sortProperty.defaultItems,
            selectedItem: state.$sortProperty.selectedFilterDial
          )
        )
      return .none

    case .tappedFloatingButton:
      state.presentDestination = .createLedger(.init())
      return .none

    case let .onAppearedLedger(property):
      if state.ledgersProperty.last?.id == property.id {
        return .send(.async(.getLedgers))
      }
      return .none

    case let .tappedLedgerBox(property):
      state.presentDestination = .detail(.init(.init(ledgerID: property.id)))
      return .none

    case .pullRefreshButton:
      return .send(.async(.getLedgersInitialPage))
    }
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedSearchButton):
      state.presentDestination = .search(.init())
      return .none

    case .header:
      return .none

    case .tabBar:
      return .none

    case .presentDestination(.presented(.sort(.changedItem))):
      return .send(.async(.getLedgersInitialPage))

    case .presentDestination(.presented(.filter(.delegate(.tappedConfirmButton)))):
      return .send(.async(.getLedgersInitialPage))

    case .presentDestination:
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
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
        categoryIds: state.filterProperty.selectedCategories.map { Int($0.id) },
        fromStartAt: state.filterProperty.isInitialStateOfStartDate ? nil : state.filterProperty.startDate,
        toStartAt: state.filterProperty.isInitialStateOfEndDate ? nil : state.filterProperty.endDate,
        page: state.page,
        sort: state.sortProperty.selectedFilterDial ?? .latest
      )
      state.isLoading = true
      return .runWithTCAMutex(state.mutexManager) { send in
        let property = try await network.getLedgers(param)
        await send(.inner(.updateLedgers(property)))
      } endOperation: { send in
        await send(.inner(.isLoading(false)))
      }

    case let .updateLedger(id):
      return .ssRun { send in
        let ledgerProperty = try await network.getLedgerByID(id)
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
    ifLet(\.$presentDestination, action: \.scope.presentDestination)
  }
}
