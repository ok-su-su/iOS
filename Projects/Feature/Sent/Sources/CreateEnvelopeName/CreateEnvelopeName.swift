//
//  CreateEnvelopeName.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct CreateEnvelopeName {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(24 / 96)))
    var textFieldText: String = ""
    var textFieldIsHighlight: Bool = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var isAbleToPush: Bool {
      return textFieldText != ""
    }

    init(createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
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

  enum ViewAction: Equatable {
    case onAppear(Bool)
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
    BindingReducer()

    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.header(.tappedDismissButton)):
        return .run { _ in
          await dismiss()
        }

      case .scope:
        return .none
      case .binding:
        return .none
      }
    }
  }
}
