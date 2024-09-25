//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import OSLog
import SSFirebase
import SSLayout
import SwiftUI

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isLoading = false
    @Shared var filterHelper: SentPeopleFilterHelper

    // MARK: - Scope

    var sliderProperty: CustomSlider = .init()

    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default), enableDismissAction: false)
    var customTextField: CustomTextField.State = .init(text: "")
    var textFieldText: String = ""
    var sliderStartValue: Int64 = 0
    var sliderEndValue: Int64 = 0

    init(filterHelper: Shared<SentPeopleFilterHelper>) {
      _filterHelper = filterHelper
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return filterHelper.sentPeople.filter { $0.name.contains(regex) }
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

  enum Action: Equatable {
    case isLoading(Bool)
    case onAppear(Bool)
    case tappedPerson(SentPerson)
    case reset
    case tappedConfirmButton
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
    case update([SentPerson])
    case getFriendsDataByName(String?)
    case getMaximumSentValue
    case updateMaximumSentValue(Int64)
    case changedSliderProperty
    case tappedSliderValueResetButton
    case tappedSlider
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.sentEnvelopeFilterNetwork) var network
  @Dependency(\.mainRunLoop) var mainQueue

  enum ThrottleID {
    case searchName
  }

  enum CancelID {
    case searchName
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }

    Scope(state: \.customTextField, action: \.customTextField) {
      CustomTextField()
    }

    Reduce { state, action in
      switch action {
      case .tappedSliderValueResetButton:
        state.sliderProperty.reset()
        state.updateSliderValueProperty()
        return .none

      case let .updateMaximumSentValue(val):
        state.sliderEndValue = val
        state.updateSliderValueProperty()
        return .none

      case .getMaximumSentValue:
        return .ssRun { send in
          let maximumValue = try await network.getMaximumSentValue()
          await send(.updateMaximumSentValue(maximumValue))
        }
      case .header(.tappedDismissButton):
        return .ssRun { send in
          await send(.reset)
          await dismiss()
        }
      case let .tappedPerson(person):
        ssLogEvent(.Sent(.filter), eventName: " 친구 버튼", eventType: .tapped)
        state.filterHelper.select(sentPerson: person)
        return .none

      case .reset:
        state.filterHelper.reset()
        state.sliderProperty.reset()
        return .none

      case .changedSliderProperty:
        state.updateSliderValueProperty()
        return .none

      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .merge(
          .ssRun { send in
            await send(.isLoading(true))
            let data = try await network.getInitialData()
            await send(.update(data))

            await send(.getMaximumSentValue)
            await send(.isLoading(false))
          },
          .publisher {
            state.sliderProperty
              .objectWillChange
              .map { _ in
                return .changedSliderProperty
              }
          },
          .publisher {
            state.sliderProperty
              .tapPublisher
              .map { _ in return .tappedSlider }
          }
        )

      case .header:
        return .none

      case let .customTextField(.changeTextField(text)):
        state.textFieldText = text
        // TODO: Throttle을 호출할 떄 주의점에 대해서 블로그 포스팅 하기
        if NameRegexManager.isValid(name: text) {
          return .send(.getFriendsDataByName(text))
        }
        return .none

      case .customTextField:
        return .none

      case .tappedConfirmButton:
        if !state.isInitialState {
          state.filterHelper.lowestAmount = state.minimumTextValue
          state.filterHelper.highestAmount = state.maximumTextValue
        }
        return .ssRun { _ in await dismiss() }

      case let .isLoading(loading):
        state.isLoading = loading
        return .none

      case let .update(items):
        state.filterHelper.updateSentPeople(items)
        return .none

      case let .getFriendsDataByName(name):
        return .ssRun { send in
          await send(.isLoading(true))
          let data: [SentPerson] = if let name {
            try await network.findFriendsByName(name)
          } else {
            try await network.getInitialData()
          }
          await send(.update(data))
          await send(.isLoading(false))
        }

      case .tappedSlider:
        ssLogEvent(.Sent(.filter), eventName: "금액 슬라이더", eventType: .tapped)
        return .none
      }
    }
  }

  init() {}
}
