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
    var floatingButton: FloatingButton.State = .init()
    var isLoading = true
    var isOnAppear = false
    var page: Int = 0
    var isEndOfPage: Bool = false

    @Presents var createEnvelopeRouter: CreateEnvelopeRouter.State?
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
  }

  @CasePathable
  enum InnerAction: Equatable {
    case showCreateEnvelopRouter
    case updateEnvelopes([EnvelopeProperty])
    case isLoading(Bool)
  }

  @CasePathable
  enum AsyncAction: Equatable {
    case updateEnvelopesByFilter
    case updateEnvelopesByFilterInitialPage
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)

    case floatingButton(FloatingButton.Action)
    case filterBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<FilterDialItem>.Action>)
    case createEnvelopeRouter(PresentationAction<CreateEnvelopeRouter.Action>)
    case sentEnvelopeFilter(PresentationAction<SentEnvelopeFilter.Action>)
    case searchEnvelope(PresentationAction<SentSearch.Action>)

    case envelopes(IdentifiedActionOf<Envelope>)
    case specificEnvelopeHistoryRouter(PresentationAction<SpecificEnvelopeHistoryRouter.Action>)
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
      case .view(.tappedEmptyEnvelopeButton):
        return .send(.inner(.showCreateEnvelopRouter))

      // Navigation Specific Router
      case let .scope(.envelopes(.element(id: _, action: .pushEnvelopeDetail(property)))):
        state.specificEnvelopeHistoryRouter = SpecificEnvelopeHistoryRouter.State(envelopeProperty: property)
        return .none

      case .scope(.header(.tappedSearchButton)):
        state.searchEnvelope = .init()
        return .none

      case .scope(.floatingButton(.tapped)):
        return .send(.inner(.showCreateEnvelopRouter))

      case .binding:
        return .none

      case .inner(.showCreateEnvelopRouter):
        state.createEnvelopeRouter = CreateEnvelopeRouter.State()
        return .none

      case .delegate(.pushFilter):
        return .none

      case .view(.tappedSortButton):
        state.filterBottomSheet = .init(items: .default, selectedItem: state.$sentMainProperty.selectedFilterDial)
        return .none

      case .view(.tappedFilterButton):
        state.sentEnvelopeFilter = SentEnvelopeFilter.State(filterHelper: state.$sentMainProperty.sentPeopleFilterHelper)
        return .none

      case .scope(.filterBottomSheet(.presented(.tapped(item: _)))):
        return .send(.async(.updateEnvelopesByFilter))

      // FilterView에서 confirmButton을 누른다면, Server에 FilterData를 요청합니다.
      case .scope(.sentEnvelopeFilter(.presented(.tappedConfirmButton))):
        return .send(.async(.updateEnvelopesByFilterInitialPage))

      // specificEnvelopeHistoryRouter가 사라지면 서버로부터 요청을 보냅니다.
      case .scope(.specificEnvelopeHistoryRouter(.dismiss)),
          .scope(.createEnvelopeRouter(.dismiss)) :
        return .send(.async(.updateEnvelopesByFilterInitialPage))

      // 만약 envelope Reducer onAppear방출시 맨 마지막 일 경우이면서, endOfPage가 아닐 경우 서버로 요청합니다.
      case let .scope(.envelopes(.element(id: uuid, action: .isOnAppear(true)))):
        if state.envelopes.last?.id == uuid && !state.isEndOfPage {
          let isEndOfPage = state.isEndOfPage.description
          os_log("페이지를 요청합니다., \(isEndOfPage.description)")
          return .send(.async(.updateEnvelopesByFilter))
            .throttle(id: ThrottleID.getFriendThrottleID, for: 2, scheduler: RunLoop.main, latest: false)
        }
        return .none

      case .scope:
        return .none

      case let .view(.onAppear(appear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = appear
        return .send(.async(.updateEnvelopesByFilter))
          .throttle(id: ThrottleID.getFriendThrottleID, for: .seconds(2), scheduler: RunLoop.main, latest: false)

      case let .inner(.updateEnvelopes(val)):
        let prevEnvelopesCount = state.envelopes.count
        let currentEnvelopeProperty = (state.envelopes.map(\.envelopeProperty) + val).uniqued()
        let uniqueElement = currentEnvelopeProperty.map { Envelope.State(envelopeProperty: $0) }
        // API 보낼 때 보내는사이즈가 30입니다. 30보다 적게 오는 경우 남은 봉투가 이보다 적다고 판단합니다.
        if prevEnvelopesCount == state.envelopes.count || val.count % 30 != 0 {
          state.isEndOfPage = true
        }
        state.envelopes = .init(uniqueElements: uniqueElement)
        return .none

      case let .inner(.isLoading(val)):
        state.isLoading = val
        return .none

      case .async(.updateEnvelopesByFilter):
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

      case let .view(.tappedFilteredPersonButton(id: id)):
        state.sentMainProperty.sentPeopleFilterHelper.select(selectedId: id)
        return .send(.async(.updateEnvelopesByFilterInitialPage))

      case .view(.tappedFilteredAmountButton):
        state.sentMainProperty.sentPeopleFilterHelper.deselectAmount()
        return .send(.async(.updateEnvelopesByFilterInitialPage))

      // 0페이지의 Envleope을 요청합니다. 현재 envelopes를 지웁니다.
      case .async(.updateEnvelopesByFilterInitialPage):
        state.page = 1
        state.isEndOfPage = false
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
    .ifLet(\.$createEnvelopeRouter, action: \.scope.createEnvelopeRouter) {
      CreateEnvelopeRouter()
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
      "handedOverAt"
    case .oldest:
      "handedOverAt, desc"
    case .highestAmount:
      "amount, desc"
    case .lowestAmount:
      "amount"
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
