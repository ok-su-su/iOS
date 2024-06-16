//
//  TermsAndConditionDetail.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
struct TermsAndConditionDetail {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State
    var detailDescription: String
    @Shared var item: TermItem
    init(item: Shared<TermItem>, detailDescription: String) {
      _item = item
      header = .init(.init(title: item.title.wrappedValue, type: .depth2Default))
      self.detailDescription = detailDescription
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedAgreeButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.header):
        return .none

      case .view(.tappedAgreeButton):
        state.item.isCheck = true
        return .run { _ in
          await dismiss()
        }
      }
    }
  }
}
