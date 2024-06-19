//
//  CreateEnvelopePrice.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct CreateEnvelopePrice {
  @ObservableState
  struct State: Equatable {
    var subscriptions: Set<AnyCancellable> = .init()
    var nextButton = CreateEnvelopeBottomOfNextButton.State()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isOnAppear = false

    var textFieldText: String = ""
    var textFieldIsHighlight: Bool = false

    private var guidPrices: [Int] = [
      10000, 30000, 50000, 100_000, 500_000,
    ]

    var formattedGuidPrices: [String] {
      return guidPrices.compactMap { CustomNumberFormatter.formattedByThreeZero($0) }
    }

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

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedGuidValue(String)
    case changeText(String)
  }

  enum InnerAction: Equatable {
    case convertPrice(String)
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
  }

  enum DelegateAction: Equatable {
    case dismissCreateFlow
  }

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

      case .delegate(.dismissCreateFlow):
        return .none
      case .binding:
        return .none

      case let .view(.tappedGuidValue(value)):
        return .run { send in
          await send(.inner(.convertPrice(value)))
        }

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.inner(.push))
        }

      case .scope(.nextButton):
        return .none

      case let .inner(.convertPrice(value)):
        state.textFieldText = value
        return .none

      case let .view(.changeText(value)):
        if let formattedValue = CustomNumberFormatter.formattedByThreeZero(value) {
          state.textFieldText = formattedValue
        }
        let pushable = state.textFieldText != ""
        return .run { send in
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }

      case .inner(.push):
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeName(.init(state.$createEnvelopeProperty)))
        return .none
      }
    }
  }
}
