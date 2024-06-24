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

    @Presents var createEnvelopeRouter: CreateEnvelopeRouter.State?
    @Presents var filterBottomSheet: SSSelectableBottomSheetReducer<FilterDialItem>.State?
    @Presents var sentEnvelopeFilter: SentEnvelopeFilter.State?
    @Presents var searchEnvelope: SearchEnvelope.State?
    @Presents var specificEnvelopeHistoryRouter: SpecificEnvelopeHistoryRouter.State?

    @Shared var sentMainProperty: SentMainProperty

    // TODO: Change With APIS
    var envelopes: IdentifiedArrayOf<Envelope.State> = []

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
    case tappedFilteredPersonButton(id: Int)
  }

  @CasePathable
  enum InnerAction: Equatable {
    case showCreateEnvelopRouter
    case updateEnvelopes([EnvelopeProperty])
    case isLoading(Bool)
  }

  @CasePathable
  enum AsyncAction: Equatable {
    case updateEnvelopes(FilterDialItem?)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)

    case floatingButton(FloatingButton.Action)
    case filterBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<FilterDialItem>.Action>)
    case createEnvelopeRouter(PresentationAction<CreateEnvelopeRouter.Action>)
    case sentEnvelopeFilter(PresentationAction<SentEnvelopeFilter.Action>)
    case searchEnvelope(PresentationAction<SearchEnvelope.Action>)

    case envelopes(IdentifiedActionOf<Envelope>)
    case specificEnvelopeHistoryRouter(PresentationAction<SpecificEnvelopeHistoryRouter.Action>)
  }

  enum DelegateAction: Equatable {
    case pushSearchEnvelope
    case pushFilter
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
      case .scope(.envelopes(.element(id: _, action: .tappedFullContentOfEnvelopeButton))):
        state.specificEnvelopeHistoryRouter = SpecificEnvelopeHistoryRouter.State()
        return .none

      case .scope(.header(.tappedSearchButton)):
        state.searchEnvelope = SearchEnvelope.State(searchHelper: state.$sentMainProperty.searchHelper)
        return .none

      case .scope(.floatingButton(.tapped)):
        return .send(.inner(.showCreateEnvelopRouter))

      case .delegate(.pushSearchEnvelope):
        return .none

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

      case let .scope(.filterBottomSheet(.presented(.tapped(item: item)))):
        return .send(.async(.updateEnvelopes(item)))

      case .scope:
        return .none

      case let .view(.onAppear(appear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = appear
        return .send(.async(.updateEnvelopes(state.sentMainProperty.selectedFilterDial)))

      case let .inner(.updateEnvelopes(val)):
        state.envelopes = .init(uniqueElements: val.map { .init(envelopeProperty: $0) })
        return .none

      case let .inner(.isLoading(val)):
        state.isLoading = val
        return .none

      case let .async(.updateEnvelopes(item)):
        return .run { send in
          await send(.inner(.isLoading(true)))
          let envelopeProperties = try await network.requestSearchFriends(item ?? .latest)
          await send(.inner(.updateEnvelopes(envelopeProperties)))
          await send(.inner(.isLoading(false)))
        }

      case let .view(.tappedFilteredPersonButton(id: id)):
        state.sentMainProperty.sentPeopleFilterHelper.select(selectedId: id)
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
      SearchEnvelope()
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
