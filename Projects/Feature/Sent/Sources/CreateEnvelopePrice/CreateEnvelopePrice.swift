//
//  CreateEnvelopePrice.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct CreateEnvelopePrice {
  @ObservableState
  struct State: Equatable {
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

    init() {}
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
    case dismissButtonTapped
    case tappedGuidValue(String)
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

      case .view(.dismissButtonTapped):
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
      }
    }
  }
}
