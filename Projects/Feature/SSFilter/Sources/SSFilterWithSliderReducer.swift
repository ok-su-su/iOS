//
//  SSFilterWithSliderReducer.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import CommonExtension
import ComposableArchitecture
import FeatureAction
import Foundation
import SSLayout

// MARK: - SSFilterWithSliderReducer

@Reducer
public struct SSFilterWithSliderReducer: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear: Bool = false
    var titleLabel: String
    @Shared var sliderProperty: SSFilterWithSliderHelper
    init(titleLabel: String) {
      _sliderProperty = .init(.init())
      self.titleLabel = titleLabel
    }
  }

  public enum Action: Equatable, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case updateSliderProperty
    case resetSliderProperty
  }

  public enum InnerAction: Equatable, Sendable {
    case updateHighestAmount(Int64)
    case updateLowestAmount(Int64)
  }

  private func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(val):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = val
      return .merge(
        .publisher {
          state.sliderProperty
            .sliderUpdatePublisher
            .map { _ in .view(.updateSliderProperty) }
        }
      )

    case .updateSliderProperty:
      state.sliderProperty.updateSliderValueProperty()
      return .none
    case .resetSliderProperty:
      state.sliderProperty.reset()
      return .none
    }
  }

  private func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case let .updateHighestAmount(val):
      state.sliderProperty.maximumTextValue = val
      return .none
    case let .updateLowestAmount(val):
      state.sliderProperty.minimumTextValue = val
      return .none
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      }
    }
  }
}
