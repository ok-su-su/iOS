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
    var nextButton = CreateEnvelopeBottomOfNextButton.State()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var isAbleToPush: Bool {
      return textFieldText != ""
    }

    var filteredPrevEnvelopes: [PrevEnvelope] {
      return textFieldText == "" ? [] : createEnvelopeProperty.filteredName(textFieldText)
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
    case tappedFilterItem(name: String)
    case textFieldChange(String)
  }

  enum InnerAction: Equatable {
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .binding:
        return .none

      case .inner(.push):
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeRelation(.init(state.$createEnvelopeProperty)))
        return .none

      case let .view(.tappedFilterItem(name: name)):
        state.textFieldText = name
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.inner(.push))
        }

      case .scope(.nextButton):
        return .none

      case let .view(.textFieldChange(text)):
        let pushable = text != ""
        return .run { send in
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }
      }
    }
  }
}
