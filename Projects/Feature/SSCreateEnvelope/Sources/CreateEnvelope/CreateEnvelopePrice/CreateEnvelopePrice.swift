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
import SSRegexManager

@Reducer
struct CreateEnvelopePrice {
  @ObservableState
  struct State: Equatable {
    var subscriptions: Set<AnyCancellable> = .init()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isOnAppear = false
    var isFocused = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: " 금액 글자수 안내", trailingType: .none))
    var wrappedText: String = ""
    var textFieldText: String = ""
    var textFieldIsHighlight: Bool = false

    var guidPrices: [Int] = [
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
    case tappedGuidValue(String)
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
      return .send(.view(.changeText(value)))

    case let .changeText(value):
      if let formattedValue = CustomNumberFormatter.formattedByThreeZero(value) {
        state.wrappedText = formattedValue
      }
      state.textFieldText = value
      // Logic to Pushable
      // 자리 보다 크고 10자리 보다 작아야 함
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
      case let .view(currentAction) :
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

extension CreateEnvelopePrice: FeatureViewAction, FeatureInnerAction {
}
