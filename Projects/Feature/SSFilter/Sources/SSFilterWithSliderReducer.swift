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
    @Shared var sliderProperty: SliderFilterProperty
    init() {
      _sliderProperty = .init(.init())
    }
  }

  public enum Action: Equatable, Sendable {
    case view(ViewAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case updateSliderProperty
  }

  public enum DelegateAction: Equatable, Sendable {
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
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case let .view(currentAction):
        return .none
      case let .delegate(currentAction):
        return .none
      }
    }
  }
}

// MARK: - SliderFilterProperty

struct SliderFilterProperty: Equatable, Sendable {
  private var sliderProperty = CustomSlider()
  private var lowestAmount: Int64? = nil
  private var highestAmount: Int64? = nil
  private var sliderEndValue: Int64 = 0
  init() {}

  public mutating func sinkFilterPublisher() -> AnyPublisher<Void, Never> {
    return sliderProperty
      .objectWillChange
      .eraseToAnyPublisher()
  }

  var sliderUpdatePublisher: AnyPublisher<Void, Never> {
    sliderProperty.objectWillChange.eraseToAnyPublisher()
  }

  mutating func deselectAmount() {
    lowestAmount = nil
    highestAmount = nil
  }

  var minimumTextValue: Int64 = 0
  var maximumTextValue: Int64 = 0
  var minimumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(minimumTextValue) ?? "0" }
  var maximumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(maximumTextValue) ?? "0" }
  var sliderRangeText: String {
    "\(minimumTextValueString)원 ~ \(maximumTextValueString)원"
  }

  var isInitialState: Bool {
    return minimumTextValue == 0 && maximumTextValue == sliderEndValue
  }

  mutating func updateSliderValueProperty() {
    minimumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentLowHandlePercentage) / 10000 * 10000
    maximumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentHighHandlePercentage) / 10000 * 10000
  }
}
