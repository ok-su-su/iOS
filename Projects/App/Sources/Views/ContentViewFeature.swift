//
//  ContentViewFeature.swift
//  susu
//
//  Created by MaraMincho on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
public struct ContentViewFeature {
  @ObservableState
  public struct State: Equatable {
    public var headerView: HeaderViewFeature.State
    public var sectionType: SSTabType
    public var tabBarView: SSTabBarFeature.State

    init(headerView: HeaderViewFeature.State) {
      let initialType = SSTabType.envelope
      sectionType = initialType
      self.headerView = headerView
      tabBarView = .init(tabbarType: initialType)
    }
  }

  public enum Action {
    case headerView(HeaderViewFeature.Action)
    case tabBarView(SSTabBarFeature.Action)
    case onAppear
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.tabBarView, action: /Action.tabBarView) {
      SSTabBarFeature()
    }
    Scope(state: \.headerView, action: /Action.headerView) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .tabBarView(.tappedSection(type)):
        state.sectionType = type
        return .run { send in
          await send(.tabBarView(.switchType(type)))
        }
      case .tabBarView:
        return .none
      case .headerView(.tappedDismissButton):
        os_log("did tap headerViewDismiss button")
        return .none
      case .headerView(.tappedSearchButton):
        os_log("did Tap Search Button")
        return .none
      case .headerView(.tappedNotificationButton):
        os_log("Did Tap Notification Button")
        return .none
      case .headerView:
        return .none
      case .onAppear:
        return .none
      }
    }
  }
}