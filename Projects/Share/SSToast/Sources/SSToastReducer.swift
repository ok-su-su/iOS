//
//  SSToast.swift
//  SSToast
//
//  Created by MaraMincho on 5/18/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Foundation

@Reducer
public struct SSToastReducer {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var sSToastProperty: SSToastProperty
    var toastMessage: String {
      return sSToastProperty.toastMessage
    }

    public init(_ sSToastProperty: SSToastProperty) {
      self.sSToastProperty = sSToastProperty
    }
  }

  public enum Action: Equatable {
    case onAppear(Bool)
    case willFinishToast
    case finishToast
    case didFinishToast
  }

  enum CancelID {
    case disappear
  }

  @Dependency(\.continuousClock) var clock

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear

        return .publisher {
          Just(true)
            .eraseToAnyPublisher()
            .delay(for: .init(state.sSToastProperty.duration), scheduler: RunLoop.main)
            .map { _ in return }
            .map { _ in return Action.didFinishToast }
        }
        .cancellable(id: CancelID.disappear, cancelInFlight: true)

      case .willFinishToast:
        return .send(.finishToast)

      case .didFinishToast:
        state.isOnAppear = false
        return .none

      case .finishToast:
        return .send(.didFinishToast)
          .cancellable(id: CancelID.disappear, cancelInFlight: true)
      }
    }
  }

  public init() {}
}
