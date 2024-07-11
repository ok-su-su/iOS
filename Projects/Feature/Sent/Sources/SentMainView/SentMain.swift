//
//  SentMain.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSBottomSelectSheet

// MARK: - SentMain

@Reducer
struct SentMain {
  init() {}

  @ObservableState
  struct State {
    // MARK: - Scope

    var header = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
    var isLoading = true
    var isOnAppear = false
    var page: Int = 0
    var isEndOfPage: Bool = false

    var presentCreateEnvelope = false
    @Presents var filterBottomSheet: SSSelectableBottomSheetReducer<FilterDialItem>.State?
    @Presents var sentEnvelopeFilter: SentEnvelopeFilter.State?
    @Presents var searchEnvelope: SentSearch.State?
    @Presents var specificEnvelopeHistoryRouter: SpecificEnvelopeHistoryRouter.State?

    @Shared var sentMainProperty: SentMainProperty

    var envelopes: IdentifiedArrayOf<Envelope.State> = []

    var isFilteredHeaderButtonItem: Bool {
      return !(sentMainProperty.sentPeopleFilterHelper.selectedPerson.isEmpty && !sentMainProperty.sentPeopleFilterHelper.isFilteredAmount)
    }

    init() {
      _sentMainProperty = Shared(.init())
    }
  }

  @Dependency(\.sentMainNetwork) var network

  enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case tappedSortButton
    case tappedFilterButton
    case tappedEmptyEnvelopeButton
    case onAppear(Bool)
    case tappedFilteredPersonButton(id: Int64)
    case tappedFilteredAmountButton
    case presentCreateEnvelope(Bool)
    case finishedCreateEnvelopes(Data)
    case tappedFloatingButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case .tappedSortButton:
      state.filterBottomSheet = .init(items: .default, selectedItem: state.$sentMainProperty.selectedFilterDial)
      return .none

    case .tappedFilterButton:
      state.sentEnvelopeFilter = SentEnvelopeFilter.State(filterHelper: state.$sentMainProperty.sentPeopleFilterHelper)
      return .none

    case .tappedEmptyEnvelopeButton:
      return .send(.inner(.showCreateEnvelopRouter))

    case let .onAppear(appear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = appear
      return .send(.async(.updateEnvelopesByFilter))
        .throttle(id: ThrottleID.getFriendThrottleID, for: .seconds(2), scheduler: RunLoop.main, latest: false)

    case let .tappedFilteredPersonButton(id):
      state.sentMainProperty.sentPeopleFilterHelper.select(selectedId: id)
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case .tappedFilteredAmountButton:
      state.sentMainProperty.sentPeopleFilterHelper.deselectAmount()
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case let .presentCreateEnvelope(present):
      state.presentCreateEnvelope = present
      return .none

    case .finishedCreateEnvelopes:
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case .tappedFloatingButton:
      return .send(.inner(.showCreateEnvelopRouter))
    }
  }

  @CasePathable
  enum InnerAction: Equatable {
    case showCreateEnvelopRouter
    case updateEnvelopes([EnvelopeProperty])
    case isLoading(Bool)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case .showCreateEnvelopRouter:
      state.presentCreateEnvelope = true
      return .none

    case let .updateEnvelopes(val):
      let prevEnvelopesCount = state.envelopes.count
      let currentEnvelopeProperty = (state.envelopes.map(\.envelopeProperty) + val).uniqued()
      let uniqueElement = currentEnvelopeProperty.map { Envelope.State(envelopeProperty: $0) }
      if prevEnvelopesCount == state.envelopes.count || val.count % 30 != 0 {
        state.isEndOfPage = true
      }
      state.envelopes = .init(uniqueElements: uniqueElement)
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  @CasePathable
  enum AsyncAction: Equatable {
    case updateEnvelopesByFilter
    case updateEnvelopesByFilterInitialPage
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .updateEnvelopesByFilter:
      let page = state.page
      state.page += 1
      let urlParameter = SearchFriendsParameter(
        friendIds: state.sentMainProperty.sentPeopleFilterHelper.selectedPerson.map(\.id),
        fromTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.lowestAmount,
        toTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.highestAmount,
        page: page,
        sort: state.sentMainProperty.selectedFilterDial ?? .highestAmount
      )
      return .run { send in
        await send(.inner(.isLoading(true)))
        let envelopeProperties = try await network.requestSearchFriends(urlParameter)
        await send(.inner(.updateEnvelopes(envelopeProperties)))
        await send(.inner(.isLoading(false)))
      }

    case .updateEnvelopesByFilterInitialPage:
      state.page = 1
      state.isEndOfPage = false
      let currentState = state.sentMainProperty.selectedFilterDial?.sortString
      os_log("current Selected Section \(currentState ?? "nil")")
      state.envelopes = .init(uniqueElements: [])
      let urlParameter = SearchFriendsParameter(
        friendIds: state.sentMainProperty.sentPeopleFilterHelper.selectedPerson.map(\.id),
        fromTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.lowestAmount,
        toTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.highestAmount,
        page: 0,
        sort: state.sentMainProperty.selectedFilterDial ?? .latest
      )
      return .run { send in
        await send(.inner(.isLoading(true)))
        let envelopeProperties = try await network.requestSearchFriends(urlParameter)
        await send(.inner(.updateEnvelopes(envelopeProperties)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case filterBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<FilterDialItem>.Action>)
    case sentEnvelopeFilter(PresentationAction<SentEnvelopeFilter.Action>)
    case searchEnvelope(PresentationAction<SentSearch.Action>)

    case envelopes(IdentifiedActionOf<Envelope>)
    case specificEnvelopeHistoryRouter(PresentationAction<SpecificEnvelopeHistoryRouter.Action>)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case let .envelopes(.element(id: _, action: .pushEnvelopeDetail(property))):
      state.specificEnvelopeHistoryRouter = SpecificEnvelopeHistoryRouter.State(envelopeProperty: property)
      return .none

    case .header(.tappedSearchButton):
      state.searchEnvelope = .init()
      return .none

    case .filterBottomSheet(.presented(.tapped(item: _))):
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case .sentEnvelopeFilter(.presented(.tappedConfirmButton)):
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case let .envelopes(.element(id: uuid, action: .isOnAppear(true))):
      if state.envelopes.last?.id == uuid && !state.isEndOfPage {
        let isEndOfPage = state.isEndOfPage.description
        os_log("페이지를 요청합니다., \(isEndOfPage)")
        return .send(.async(.updateEnvelopesByFilter))
          .throttle(id: ThrottleID.getFriendThrottleID, for: 2, scheduler: RunLoop.main, latest: false)
      }
      return .none

    case .searchEnvelope,
         .specificEnvelopeHistoryRouter,
         .tabBar:
      return .none

    default:
      return .none
    }
  }

  enum DelegateAction: Equatable {
    case pushFilter
  }

  private enum ThrottleID {
    case getFriendThrottleID
  }

  var body: some Reducer<State, Action> {
    // MARK: - Scope Child Reducers

    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }

    BindingReducer()

    // MARK: - Reducer

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)

      case .binding:
        return .none

      case .delegate:
        return .none
      }
    }
    .subFeatures1()
    .subFeatures2()
  }
}

private extension Reducer where State == SentMain.State, Action == SentMain.Action {
  func subFeatures1() -> some ReducerOf<Self> {
    ifLet(\.$searchEnvelope, action: \.scope.searchEnvelope) {
      SentSearch()
    }
    .ifLet(\.$sentEnvelopeFilter, action: \.scope.sentEnvelopeFilter) {
      SentEnvelopeFilter()
    }
  }

  func subFeatures2() -> some ReducerOf<Self> {
    ifLet(\.$filterBottomSheet, action: \.scope.filterBottomSheet) {
      SSSelectableBottomSheetReducer()
    }
    .ifLet(\.$specificEnvelopeHistoryRouter, action: \.scope.specificEnvelopeHistoryRouter) {
      SpecificEnvelopeHistoryRouter()
    }
    .forEach(\.envelopes, action: \.scope.envelopes) {
      Envelope()
    }
  }
}

// MARK: - FilterDialItem

enum FilterDialItem: Int, SSSelectBottomSheetPropertyItemable {
  case latest = 0
  case oldest
  case highestAmount
  case lowestAmount

  var description: String {
    switch self {
    case .latest:
      "최신순"
    case .oldest:
      "오래된순"
    case .highestAmount:
      "금액 높은 순"
    case .lowestAmount:
      "금액 낮은 순"
    }
  }

  var id: Int { rawValue }

  var sortString: String {
    switch self {
    case .latest:
      "createdAt,desc"
    case .oldest:
      "createdAt,asc"
    case .highestAmount:
      "amount,desc"
    case .lowestAmount:
      "amount,asc"
    }
  }
}

extension [FilterDialItem] {
  static var `default`: Self {
    return [
      .latest,
      .oldest,
      .highestAmount,
      .lowestAmount,
    ]
  }

  static var initialValue: FilterDialItem {
    .latest
  }
}

// MARK: - SentMain + FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction

extension SentMain: FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction {}
