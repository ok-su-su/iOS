//
//  CreateEnvelopeDate.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

@Reducer
struct CreateEnvelopeDate {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var yearTextFieldText: String = ""
    var monthTextFieldText: String = ""
    var dayTextFieldText: String = ""

    var yearTextFieldValid: Bool {
      // some logic
      return true
    }

    var monthTextFieldValid: Bool {
      // some logic
      return true
    }

    var dayTextFieldValid: Bool {
      // some logic
      return true
    }

    var isAbleToPush: Bool {
      return yearTextFieldValid && monthTextFieldValid && dayTextFieldValid
    }

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .binding:
        return .none

      case .view(.tappedNextButton):
        return .run { send in
          await send(.inner(.push))
        }

      case .inner(.push):
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeAdditionalSection(.init(state.$createEnvelopeProperty)))
        return .none
      }
    }
  }
}
