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

  enum Action: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case tappedFirstButton
    case filterButtonTapped
    case tappedEmptyEnvelopeButton
    case envelopes(IdentifiedActionOf<Envelope>)
    case filterDial(FilterDial.Action)
    case setFilterDialSheet(Bool)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: /Action.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.filterDial, action: \.filterDial) {
      FilterDial()
    }
    .onChange(of: \.filterDial.filterDialProperty) { _, newValue in
      Reduce { state, _ in
        state.filterDialProperty = newValue
        return .none
      }
    }
    Reduce { state, action in
      switch action {
      case .header(.tappedSearchButton):
        return .none
      case .header:
        return .none
      case .setFilterDialSheet(true):
        state.isDialPresented = true
        return .none
      case .setFilterDialSheet(false):
        state.isDialPresented = false
        return .none
      case .tappedFirstButton:
        return .none
      case .filterButtonTapped:
        return .none
      case .tabBar:
        return .none
      case .envelopes:
        return .none
      case .filterDial:
        return .none
      case .tappedEmptyEnvelopeButton:
        return .none
      }
    }
    .forEach(\.envelopes, action: \.envelopes) {
      Envelope()
    }
  }
}
