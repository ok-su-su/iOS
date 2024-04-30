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
    var filterProperty: FilterProperty?
    var header = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
    var envelopes: IdentifiedArrayOf<Envelope.State> = [
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
      .init(envelopeProperty: .init()),
    ]
    init() {
      self.filterProperty = nil
    }
    
    init(filterProperty: FilterProperty) {
      self.filterProperty = filterProperty
    }
  }

  enum Action: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case tappedFirstButton
    case filterButtonTapped
    case tappedEmptyEnvelopeButton
    case envelopes(IdentifiedActionOf<Envelope>)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: /Action.tabBar) {
      SSTabBarFeature()
    }
    Reduce { _, action in
      switch action {
      case .tappedFirstButton:
        os_log("Tapped First Button")
        return .none

      case .filterButtonTapped:
        os_log("filterButtonTapped")
        return .none
      default:
        return .none
      }
    }
    .forEach(\.envelopes, action: \.envelopes) {
      Envelope()
    }
  }
}
