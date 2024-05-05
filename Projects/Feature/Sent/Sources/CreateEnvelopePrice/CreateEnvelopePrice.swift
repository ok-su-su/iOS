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

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isOnAppear = false
    var tabBar: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(12 / 96)))

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

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedGuidValue(String)
    case changeText(String)
  }

  enum InnerAction: Equatable {
    case convertPrice(String)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {
    case dismissCreateFlow
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.tabBar(.tappedDismissButton)):
        return .run { send in
          await send(.delegate(.dismissCreateFlow))
        }

      case .scope:
        return .none

      case .delegate(.dismissCreateFlow):
        return .none
      case .binding:
        return .none

      case let .view(.tappedGuidValue(value)):
        return .run { send in
          await send(.inner(.convertPrice(value)))
        }
      case let .inner(.convertPrice(value)):
        state.textFieldText = value
        return .none

      case let .view(.changeText(value)):
        if let formattedValue = CustomNumberFormatter.formattedByThreeZero(value) {
          state.textFieldText = formattedValue
        }
        return .none
      }
    }
  }
}
