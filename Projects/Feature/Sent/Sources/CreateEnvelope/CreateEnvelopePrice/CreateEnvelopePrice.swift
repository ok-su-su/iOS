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
import FeatureAction
import Foundation
import OSLog
import SSToast

@Reducer
struct CreateEnvelopePrice {
  @ObservableState
  struct State: Equatable {
    var subscriptions: Set<AnyCancellable> = .init()
    var nextButton = CreateEnvelopeBottomOfNextButton.State()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isOnAppear = false
    var isFocused = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: " 금액 글자수 안내", trailingType: .none, duration: 2))
    var wrappedText: String = ""
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
    case updateRequestBody
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable {
    case dismissCreateFlow
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }

    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        state.isFocused = true
        return .none

      case .delegate(.dismissCreateFlow):
        return .none
      case .binding:
        return .none

      case let .view(.tappedGuidValue(value)):
        return .send(.view(.changeText(value)))

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
          state.wrappedText = formattedValue
        }
        state.textFieldText = value
        // Logic to Pushable
        let pushable = value.count < 10
        return .run { send in
          if !pushable {
            await send(.scope(.toast(.showToastMessage("100억 미만의 금액만 입력 가능합니다."))))
          }
          await send(.scope(.nextButton(.delegate(.isAbleToPush(pushable)))))
        }

      case .inner(.push):
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeName(.init(state.$createEnvelopeProperty)))
        return .run { send in
          await send(.inner(.updateRequestBody))
        }

      case .scope(.toast):
        return .none

      case .inner(.updateRequestBody):
        let body = CreateEnvelopeRequestBody(type: "SENT")
        SharedContainer.setValue(body)
        return .none
      }
    }
  }
}
