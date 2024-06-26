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

    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default), enableDismissAction: false)
    var customTextField: CustomTextField.State = .init(text: "")
    var textFieldText: String = ""
    var sliderStartValue: Double = 0
    var sliderEndValue: Double = 100_000

    init(filterHelper: Shared<SentPeopleFilterHelper>) {
      _filterHelper = filterHelper
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return filterHelper.sentPeople.filter { $0.name.contains(regex) }
    }
  }

  enum Action: Equatable {
    case isLoading(Bool)
    case onAppear(Bool)
    case tappedPerson(Int64)
    case tappedSelectedPerson(Int64)
    case reset
    case tappedConfirmButton(lowest: Int64? = nil, highest: Int64? = nil)
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
    case update([SentPerson])
    case getFriendsDataByName(String?)
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
      case .header(.tappedDismissButton):
        return .run { send in
          await send(.reset)
          await dismiss()
        }
      case let .tappedPerson(ind):
        state.filterHelper.select(selectedId: ind)
        return .none

      case let .tappedSelectedPerson(ind):
        state.filterHelper.select(selectedId: ind)
        return .none

      case .reset:
        state.filterHelper.reset()
        return .none

      case let .onAppear(isAppear):
        os_log("필터 뷰 생겼음!")
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .run { send in
          await send(.isLoading(true))
          let data = try await network.getInitialData()
          await send(.update(data))
          await send(.isLoading(false))
        }

      case .header:
        return .none

      case let .customTextField(.changeTextField(text)):
        state.textFieldText = text
        // TODO: Throttle을 호출할 떄 주의점에 대해서 블로그 포스팅 하기
        if NameRegexManager.isValid(name: text) {
          return .send(.getFriendsDataByName(text))
            .throttle(id: ThrottleID.searchName, for: .seconds(2), scheduler: mainQueue, latest: true)
        }
        return .none

      case .customTextField:
        return .none

      case let .tappedConfirmButton(lowestVal, highestVal):
        // 만약 입력된 값이 초기값과 똑같지 않을 경우(Slider에 변화가 있을 경우)
        if !(lowestVal == Int64(state.sliderStartValue) && highestVal == Int64(state.sliderEndValue)) {
          state.filterHelper.lowestAmount = lowestVal
          state.filterHelper.highestAmount = highestVal
        }
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
