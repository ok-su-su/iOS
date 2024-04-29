//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
public struct SentEnvelopeFilter {
  @ObservableState
  public struct State {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var headerView = HeaderViewFeature.State(.init(type: .depth2Text("asdf")))
  }

  public enum Action: Equatable {
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case headerView(HeaderViewFeature.Action)
    case tappedButton
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    Scope(state: \.header, action: /Action.header) {
      HeaderViewFeature()
    }
    Scope(state: \.headerView, action: /Action.headerView) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case .tappedButton:
        return .none
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .header(.tappedDismissButton):
        return .run { _ in
          await dismiss()
        }
      default:
        return .none
      }
    }
  }

  public init() {}
}
