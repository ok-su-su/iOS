//
//  SentMain.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
struct SentMain {
  init() {}
  @ObservableState
  struct State {
    // MARK: - Scope

    var header = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
    var floatingButton: FloatingButton.State = .init()

    @Presents var createEnvelopeRouter: CreateEnvelopeRouter.State?
    @Presents var filterDial: FilterDial.State?
    @Presents var sentEnvelopeFilter: SentEnvelopeFilter.State?
    @Presents var searchEnvelope: SearchEnvelope.State?

    @Shared var sentMainProperty: SentMainProperty

    // TODO: Change With APIS
    var envelopes: IdentifiedArrayOf<Envelope.State> = [
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
    ]

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
  }

  @CasePathable
  enum InnerAction: Equatable {
    case showCreateEnvelopRouter
  }

  @CasePathable
  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)

    case floatingButton(FloatingButton.Action)

    case filterDial(PresentationAction<FilterDial.Action>)
    case createEnvelopeRouter(PresentationAction<CreateEnvelopeRouter.Action>)
    case sentEnvelopeFilter(PresentationAction<SentEnvelopeFilter.Action>)
    case searchEnvelope(PresentationAction<SearchEnvelope.Action>)

    case envelopes(IdentifiedActionOf<Envelope>)
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
        return .none

      case .scope(.tabBar):
        return .none
      case .scope(.envelopes):
        return .none
      case .scope(.filterDial):
        return .none
      case .scope(.header(.tappedSearchButton)):
        state.searchEnvelope = SearchEnvelope.State(searchHelper: state.$sentMainProperty.searchHelper)
        return .none

      case .scope(.header):
        return .none

      case .scope(.floatingButton(.tapped)):
        return .run { send in
          await send(.inner(.showCreateEnvelopRouter))
        }

      case .delegate(.pushSearchEnvelope):
        return .none

      case .binding:
        return .none

      case .inner(.showCreateEnvelopRouter):
        state.createEnvelopeRouter = .init()
        return .none

      case .scope(.createEnvelopeRouter):
        return .none

      case .delegate(.pushFilter):
        return .none

      case .view(.tappedSortButton):
        state.filterDial = .init(filterDialProperty: state.$sentMainProperty.filterDialProperty)
        return .none

      case .view(.tappedFilterButton):
        state.sentEnvelopeFilter = .init(filterHelper: state.$sentMainProperty.sentPeopleFilterHelper)
        return .none

      case .scope(.sentEnvelopeFilter):
        return .none

      case .scope(.searchEnvelope):
        return .none
      }
    }
    .ifLet(\.$searchEnvelope, action: \.scope.searchEnvelope) {
      SearchEnvelope()
    }
    .ifLet(\.$sentEnvelopeFilter, action: \.scope.sentEnvelopeFilter) {
      SentEnvelopeFilter()
    }
    .ifLet(\.$createEnvelopeRouter, action: \.scope.createEnvelopeRouter) {
      CreateEnvelopeRouter()
    }
    .ifLet(\.$filterDial, action: \.scope.filterDial) {
      FilterDial()
    }
    .forEach(\.envelopes, action: \.scope.envelopes) {
      Envelope()
    }
  }
}
