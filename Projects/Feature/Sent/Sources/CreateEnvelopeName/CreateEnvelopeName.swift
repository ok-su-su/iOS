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
    var textFieldText: String = ""
    var textFieldIsHighlight: Bool = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var isAbleToPush: Bool {
      return textFieldText != ""
    }

    var filteredPrevEnvelopes: [PrevEnvelope] {
      return textFieldText == "" ? [] : createEnvelopeProperty.filteredName(textFieldText)
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {
    case push
  }

  @Dependency(\.dismiss) var dismiss

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
        return .run {send in
          await send(.delegate(.push))
        }
        
      case .delegate(_):
        return .none
      }
    }
  }
}
