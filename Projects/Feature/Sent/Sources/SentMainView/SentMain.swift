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
    var networkHelper = SentMainNetwork()
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
    case tappedFilteredPersonButton(id: UUID)
  }

  @CasePathable
  enum InnerAction: Equatable {
    case showCreateEnvelopRouter
    case updateEnvelopes([EnvelopeProperty])
    case isLoading(Bool)
  }

  @CasePathable
  enum AsyncAction: Equatable {}

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

      case .scope:
        return .none
      case let .view(.onAppear(appear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = appear

        return .run { [helper = state.networkHelper] send in
          await send(.inner(.isLoading(true)))
          let envelopeProperties = try await helper.requestInitialScreenData()
          await send(.inner(.updateEnvelopes(envelopeProperties)))
          await send(.inner(.isLoading(false)))
        }
      case let .inner(.updateEnvelopes(val)):
        state.envelopes = .init(uniqueElements: val.map { .init(envelopeProperty: $0) })
        return .none

      case let .inner(.isLoading(val)):
        state.isLoading = val
        return .none

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

struct FilterDialItem: SSSelectBottomSheetPropertyItemable {
  var description: String
  var id: Int

  init(description: String, id: Int) {
    self.description = description
    self.id = id
  }
}

extension [FilterDialItem] {
  static var `default`: Self {
    return [
      .init(description: "최신순", id: 0),
      .init(description: "오래된순", id: 1),
      .init(description: "금액 높은 순", id: 2),
      .init(description: "금액 낮은 순", id: 3),
    ]
  }

  static var initialValue: FilterDialItem {
    .init(description: "최신순", id: 0)
  }
}
