//
//  LedgerDetailFilter.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSLayout

// MARK: - LedgerDetailFilter

@Reducer
struct LedgerDetailFilter: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var textFieldText: String = ""
    @Shared var property: LedgerDetailFilterProperty
    var prevProperty: LedgerDetailFilterProperty
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var isLoading = true
    var ledgerProperty = SharedContainer.getValue(LedgerDetailProperty.self)

    var sliderProperty: CustomSlider = .init()
    var sliderEndValue: Int64 = 100_000
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

    var filterByTextField: [LedgerFilterItemProperty] = []

    mutating func updateSliderValueProperty() {
      minimumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentLowHandlePercentage) / 10000 * 10000
      maximumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentHighHandlePercentage) / 10000 * 10000
    }

    init(_ property: Shared<LedgerDetailFilterProperty>) {
      _property = property
      prevProperty = property.wrappedValue
    }
  }

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedItem(LedgerFilterItemProperty)
    case changeTextField(String)
    case closeButtonTapped
    case tappedConfirmButton
    case reset
    case tappedSliderResetButton
  }

  enum InnerAction: Equatable, Sendable {
    case isLoading(Bool)
    case updateItems([LedgerFilterItemProperty])
    case updateMaximumReceivedValue(Int64)
    case updateSliderPropertyItems
  }

  enum AsyncAction: Equatable, Sendable {
    case searchInitialFriends
    case searchFriendsBy(name: String)
    case getInitialMaxPriceValue
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable, Sendable {}

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.mainQueue) var mainQueue

  private enum CancelID {
    case searchTextField
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .merge(
        .send(.async(.searchInitialFriends)),
        .send(.async(.getInitialMaxPriceValue)),
        .publisher {
          state
            .sliderProperty
            .objectWillChange
            .map { _ in .inner(.updateSliderPropertyItems) }
        }
      )

    case let .tappedItem(item):
      state.property.select(item.id)
      return .none

    case let .changeTextField(text):
      state.textFieldText = text
      return .send(.async(.searchFriendsBy(name: text)))
        .throttle(id: CancelID.searchTextField, for: 0.1, scheduler: mainQueue, latest: true)

    case .closeButtonTapped:
      state.textFieldText = ""
      return .none

    case .tappedConfirmButton:
      if !state.isInitialState {
        state.property.lowestAmount = state.minimumTextValue
        state.property.highestAmount = state.maximumTextValue
      }
      return .ssRun { _ in
        await dismiss()
      }

    case .reset:
      state.sliderProperty.reset()
      state.property.reset()
      return .none

    case .tappedSliderResetButton:
      state.sliderProperty.reset()
      return .none
    }
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header:
      return .none
    }
  }

  private func filterItems(_ state: inout State) {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(state.textFieldText)[\\w\\p{L}]*") else {
      return
    }
    state.filterByTextField = state.property.selectableItems.filter { $0.title.contains(regex) }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateItems(items):
      let uniqueItem = (state.property.selectableItems + items).uniqued()
      state.property.selectableItems = uniqueItem
      filterItems(&state)
      return .none

    case let .updateMaximumReceivedValue(price):
      state.sliderEndValue = price
      state.updateSliderValueProperty()
      return .none

    case .updateSliderPropertyItems:
      state.updateSliderValueProperty()
      return .none
    }
  }

  @Dependency(\.ledgerDetailFilterNetwork) var network
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .searchInitialFriends:
      guard let id = state.ledgerProperty?.id else {
        return .none
      }
      return .ssRun { send in
        await send(.inner(.isLoading(true)))
        // 초기 친구 검색
        let items = try await network.getInitialDataByLedgerID(id)
        await send(.inner(.updateItems(items)))
        await send(.inner(.isLoading(false)))
      }

    case let .searchFriendsBy(name):
      guard let id = state.ledgerProperty?.id else {
        return .none
      }
      return .ssRun { send in
        let items = try await network.findFriendsBy(.init(name: name, ledgerID: id))
        await send(.inner(.updateItems(items)))
      }
    case .getInitialMaxPriceValue:
      return .ssRun { send in
        let price = try await network.getMaximumSentValue()
        await send(.inner(.updateMaximumReceivedValue(price)))
      }
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

extension Reducer where Self.State == LedgerDetailFilter.State, Self.Action == LedgerDetailFilter.Action {}
