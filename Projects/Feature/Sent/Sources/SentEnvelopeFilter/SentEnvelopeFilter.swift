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
import SSFilter
import SSFirebase
import SSLayout
import SSRegexManager
import SwiftUI

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var isLoading = false
    @Shared var filterHelper: SentPeopleFilterHelper

    // MARK: - Scope

    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default), enableDismissAction: false)

    var filterState = SSFilterReducer<SentPerson>.State(type: .withSlider(titleLabel: "전체금액"), isSearchSection: true)

    init(filterHelper: Shared<SentPeopleFilterHelper>) {
      _filterHelper = filterHelper
    }
  }

  enum Action: Equatable, Sendable {
    case isLoading(Bool)
    case onAppear(Bool)
    case header(HeaderViewFeature.Action)
    case filterAction(SSFilterReducer<SentPerson>.Action)
    case getFriendsDataByName(String?)
    case tappedConfirmButton
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

    Scope(state: \.filterState, action: \.filterAction) {
      SSFilterReducer()
    }

    Reduce { state, action in
      switch action {
      case .header(.tappedDismissButton):
        return .run { _ in
          await dismiss()
        }

      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        let prevSelectedItems = state.filterHelper.selectedPerson
        let prevMinimumValue = state.filterHelper.lowestAmount
        let prevMaximumValue = state.filterHelper.highestAmount
        return .merge(
          .send(.filterAction(.inner(
            .updatePrevSelectedFilteredItemsAndSlider(item: prevSelectedItems, minimumValue: prevMinimumValue, maximumValue: prevMaximumValue)
          ))),
          .ssRun { send in
            await send(.isLoading(true))
            let data = try await network.getInitialData()
            await send(.filterAction(.inner(.updateItems(data))))
            let maximumValue = try await network.getMaximumSentValue()
            await send(.filterAction(.inner(.updateSliderMaximumValue(maximumValue))))

            await send(.isLoading(false))
          }
        )

      case .header:
        return .none

      case .tappedConfirmButton:
        return .none

      case let .isLoading(loading):
        state.isLoading = loading
        return .none

      case let .getFriendsDataByName(name):
        return .ssRun { send in
          await send(.isLoading(true))
          let data: [SentPerson] = if let name {
            try await network.findFriendsByName(name)
          } else {
            try await network.getInitialData()
          }
          await send(.filterAction(.inner(.updateItems(data))))
          await send(.isLoading(false))
        }

      case let .filterAction(currentAction):
        return filterEffect(&state, currentAction)
      }
    }
  }

  private func filterEffect(_ state: inout State, _ action: SSFilterReducer<SentPerson>.Action) -> Effect<Action> {
    switch action {
    case let .delegate(.changeTextField(text)):
      if RegexManager.isValidName(text) {
        return .send(.getFriendsDataByName(text))
      }
      return .none

    case let .delegate(.tappedConfirmButtonWithSliderProperty(selectedItems, minimumValue, maximumValue)):
      state.filterHelper.select(sentPeople: selectedItems)
      if let minimumValue, let maximumValue {
        state.filterHelper.lowestAmount = minimumValue
        state.filterHelper.highestAmount = maximumValue
      }
      return .run { send in
        await send(.tappedConfirmButton)
        await dismiss()
      }

    case .delegate:
      return .none

    default:
      return .none
    }
  }

  init() {}
}
