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
    public var sectionType: SSTabType = .envelope

    init(headerView: HeaderViewFeature.State) {
      self.headerView = headerView
      sectionType = sectionType
    }
  }

  public enum Action {
    case headerView(HeaderViewFeature.Action)
    case tapSectionButton(SSTabType)
    case onAppear
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
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
      case let .tapSectionButton(type):
        switch type {
        case .envelope:
          state.sectionType = .envelope
          return .none
        case .inventory:
          state.sectionType = .inventory
          return .none
        case .statistics:
          state.sectionType = .statistics
          return .none
        case .vote:
          state.sectionType = .vote
          return .none
        case .mypage:
          state.sectionType = .mypage
          return .none

        default:
          return .none
        }
      }
    }
  }
}
