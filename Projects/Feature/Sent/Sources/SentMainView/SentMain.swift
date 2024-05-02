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
    var header = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
    var isDialPresented = false
    var filterProperty: FilterProperty?
    var filterDialProperty: FilterDialProperty
    var filterDial: FilterDial.State
    var floatingButton: FloatingButton.State = .init()
    var envelopes: IdentifiedArrayOf<Envelope.State> = [
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
    ]

    init(filterProperty: FilterProperty? = nil) {
      self.filterProperty = filterProperty

      let initialType: FilterDialProperty = .init(currentType: .newest)
      filterDialProperty = initialType
      filterDial = .init(filterDialProperty: initialType)
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
    case tappedFirstButton
    case filterButtonTapped
    case tappedEmptyEnvelopeButton
    case setFilterDialSheet(Bool)
  }

  @CasePathable
  enum InnerAction: Equatable {}

  @CasePathable
  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case filterDial(FilterDial.Action)
    case floatingButton(FloatingButton.Action)

    case envelopes(IdentifiedActionOf<Envelope>)
    case setFilterDialSheet(Bool)
  }

  enum DelegateAction: Equatable {
    case pushSearchEnvelope
  }

  var body: some Reducer<State, Action> {
    // MARK: - Scope Child Reducers

    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.filterDial, action: \.scope.filterDial) {
      FilterDial()
    }
    .onChange(of: \.filterDial.filterDialProperty) { _, newValue in
      Reduce { state, _ in
        state.filterDialProperty = newValue
        return .none
      }
    }

    BindingReducer()

    // MARK: - Reducer

    Reduce { state, action in
      switch action {
      case .view(.setFilterDialSheet(true)):
        state.isDialPresented = true
        return .none

      case .view(.setFilterDialSheet(false)):
        state.isDialPresented = false
        return .none

      case .view(.tappedFirstButton):
        return .none

      case .view(.filterButtonTapped):
        return .none

      case .view(.tappedEmptyEnvelopeButton):
        return .none

      case .scope(.tabBar):
        return .none
      case .scope(.envelopes):
        return .none
      case .scope(.filterDial):
        return .none
      case .scope(.header(.tappedSearchButton)):
        return .run { send in
          await send(.delegate(.pushSearchEnvelope))
        }
      case .scope(.header):
        return .none
      case .scope(.setFilterDialSheet):
        return .none
      case .scope(.floatingButton(.tapped)):
        
        return .none

      case .delegate(.pushSearchEnvelope):
        return .none

      case .binding:
        return .none
      }
    }
    .forEach(\.envelopes, action: \.scope.envelopes) {
      Envelope()
    }
  }
}
