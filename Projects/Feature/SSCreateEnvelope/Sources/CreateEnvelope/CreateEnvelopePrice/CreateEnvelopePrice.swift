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
import SSRegexManager
import SSToast

// MARK: - CreateEnvelopePrice

@Reducer
struct CreateEnvelopePrice {
  @ObservableState
  struct State: Equatable {
    var subscriptions: Set<AnyCancellable> = .init()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isOnAppear = false
    var isFocused = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: " 금액 글자수 안내", trailingType: .none))
    /// TextField 를 래핑한 값을 저장합니다.
    var wrappedText: String = ""
    /// 숫자만 저장합니다.
    var textFieldText: String = ""
    var textFieldIsHighlight: Bool = false

    var guidPrices: [Int64] = [
      10000, 30000, 50000, 100_000, 500_000,
    ]

    var formattedGuidPrices: [String] {
      return guidPrices.compactMap { CustomNumberFormatter.formattedByThreeZero($0) }
    }

    var isAbleToPush: Bool = false

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
    case tappedGuidValue(Int64)
    case changeText(String)
    case tappedNextButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      state.isFocused = true
      return .none

    case let .tappedGuidValue(value):
      return .send(.inner(.addPrice(value)))

    case let .changeText(value):
      if let formattedValue = CustomNumberFormatter.formattedByThreeZero(value) {
        state.wrappedText = formattedValue
      }
      state.textFieldText = value
      let pushable = RegexManager.isValidPrice(value)
      let isShowToast = ToastRegexManager.isShowToastByGift(value)
      state.isAbleToPush = pushable
      return isShowToast ?
        .send(.scope(.toast(.showToastMessage("100억 미만의 금액만 입력 가능합니다.")))) : .none

    case .tappedNextButton:
      return .send(.inner(.push))
    }
  }

  enum InnerAction: Equatable {
    case convertPrice(String)
    case push
    case addPrice(Int64)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case let .convertPrice(value):
      state.textFieldText = value
      return .none

    case .push:
      if let amount = Int64(state.textFieldText) {
        CreateEnvelopeRequestShared.setAmount(amount)
      }
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeName(.init(state.$createEnvelopeProperty)))
      return .none

    case let .addPrice(value):
      if state.textFieldText.isEmpty {
        state.textFieldText = "0"
      }
      if let currentPrice = Int64(state.textFieldText) {
        let addedValue = currentPrice + value
        return .send(.view(.changeText(addedValue.description)))
      }
      return .none
    }
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case toast(SSToastReducer.Action)
  }

  enum DelegateAction: Equatable {
    case dismissCreateFlow
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case .delegate(.dismissCreateFlow):
        return .none
      case .binding:
        return .none

      case .scope(.toast):
        return .none
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureInnerAction

extension CreateEnvelopePrice: FeatureViewAction, FeatureInnerAction {}
