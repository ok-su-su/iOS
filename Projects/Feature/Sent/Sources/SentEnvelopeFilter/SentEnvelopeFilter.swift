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
import SSLayout
import SwiftUI

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var isLoading = false
    @Shared var filterHelper: SentPeopleFilterHelper

    // MARK: - Scope

    @Shared var sliderProperty: CustomSlider

    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default), enableDismissAction: false)
    var customTextField: CustomTextField.State = .init(text: "")
    var textFieldText: String = ""
    var sliderStartValue: Int64 = 0
    var sliderEndValue: Int64 = 100_000

    init(filterHelper: Shared<SentPeopleFilterHelper>) {
      _filterHelper = filterHelper
      _sliderProperty = .init(.init())
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return filterHelper.sentPeople.filter { $0.name.contains(regex) }
    }

    var minimumTextValue: Int64 { Int64(Double(sliderEndValue) * sliderProperty.currentLowHandlePercentage) / 10000 * 10000 }
    var maximumTextValue: Int64 { Int64(Double(sliderEndValue) * sliderProperty.currentHighHandlePercentage) / 10000 * 10000 }
    var sliderRangeText: String {
      "\(minimumTextValue)원 ~ \(maximumTextValue)원"
    }

    var isInitialState: Bool {
      false
    }
  }

  enum Action: Equatable {
    case isLoading(Bool)
    case onAppear(Bool)
    case tappedPerson(SentPerson)
    case reset
    case tappedConfirmButton(lowest: Int64? = nil, highest: Int64? = nil)
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
    case update([SentPerson])
    case getFriendsDataByName(String?)
    case getMaximumSentValue
    case updateMaximumSentValue(Int64)
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
      case let .updateMaximumSentValue(val):
        state.sliderEndValue = val
        return .none

      case .getMaximumSentValue:
        return .run { send in
          let maximumValue = try await network.getMaximumSentValue()
          await send(.updateMaximumSentValue(maximumValue))
        }
      case .header(.tappedDismissButton):
        return .run { send in
          await send(.reset)
          await dismiss()
        }
      case let .tappedPerson(person):
        state.filterHelper.select(sentPerson: person)
        return .none

      case .reset:
        state.filterHelper.reset()
        state.sliderProperty.reset()
        return .none

      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .run { send in
          await send(.isLoading(true))
          let data = try await network.getInitialData()
          await send(.update(data))

          await send(.getMaximumSentValue)
          await send(.isLoading(false))
        }

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

      case let .tappedConfirmButton(lowestVal, highestVal):
        // 만약 입력된 값이 초기값과 똑같지 않을 경우(Slider에 변화가 있을 경우)
        // TODO: Slider적용하는 기능 생성
//        if !(lowestVal == Int64(state.sliderStartValue) && highestVal == Int64(state.sliderEndValue)) {
//          state.filterHelper.lowestAmount = lowestVal
//          state.filterHelper.highestAmount = highestVal
//        }
        return .run { _ in await dismiss() }

      case let .isLoading(loading):
        state.isLoading = loading
        return .none

      case let .update(items):
        state.filterHelper.updateSentPeople(items)
        return .none
      case let .getFriendsDataByName(name):
        return .run { send in
          await send(.isLoading(true))
          let data: [SentPerson] = if let name {
            try await network.findFriendsBy(name: name)
          } else {
            try await network.getInitialData()
          }
          await send(.update(data))
          await send(.isLoading(false))
        }
      }
    }
  }

  init() {}
}
