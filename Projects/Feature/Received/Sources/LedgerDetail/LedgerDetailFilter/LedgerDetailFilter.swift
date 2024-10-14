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
import SSFilter
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
    var filterState: SSFilterReducer<LedgerFilterItemProperty>.State = .init(type: .withSlider(titleLabel: "받은 봉투 금액"), isSearchSection: true)

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
  }

  enum InnerAction: Equatable, Sendable {
    case isLoading(Bool)
  }

  enum AsyncAction: Equatable, Sendable {
    case searchInitialFriends
    case searchFriendsBy(name: String)
    case getInitialMaxPriceValue
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
    case filterAction(SSFilterReducer<LedgerFilterItemProperty>.Action)
  }

  enum DelegateAction: Equatable, Sendable {
    case tappedConfirmButton
  }

  func handleFilterAction(_ state: inout State, _ action: SSFilterReducer<LedgerFilterItemProperty>.Action) -> Effect<Action> {
    switch action {
    case let .delegate(.changeTextField(text)):
      return .send(.async(.searchFriendsBy(name: text)))
        .throttle(id: CancelID.searchTextField, for: 0.1, scheduler: mainQueue, latest: true)

    case let .delegate(.tappedConfirmButtonWithSliderProperty(selectedItems, minimumValue, maximumValue)):
      state.property.selectItems(selectedItems)
      if let minimumValue, let maximumValue {
        state.property.lowestAmount = minimumValue
        state.property.highestAmount = maximumValue
      }
      return .send(.delegate(.tappedConfirmButton))

    case .delegate:
      return .none

    default:
      return .none
    }
  }

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
        .send(.async(.getInitialMaxPriceValue))
      )
    }
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case let .filterAction(currentAction):
      return handleFilterAction(&state, currentAction)
    case .header:
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
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
        await send(.scope(.filterAction(.inner(.updateItems(items)))))
        await send(.inner(.isLoading(false)))
      }

    case let .searchFriendsBy(name):
      guard let id = state.ledgerProperty?.id else {
        return .none
      }
      return .ssRun { send in
        let items = try await network.findFriendsBy(.init(name: name, ledgerID: id))
        await send(.scope(.filterAction(.inner(.updateItems(items)))))
      }

    case .getInitialMaxPriceValue:
      return .ssRun { send in
        let price = try await network.getMaximumSentValue()
        await send(.scope(.filterAction(.inner(.updateSliderMaximumValue(price)))))
      }
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.filterState, action: \.scope.filterAction) {
      SSFilterReducer()
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
      case .delegate:
        return .none
      }
    }
  }
}

extension Reducer where Self.State == LedgerDetailFilter.State, Self.Action == LedgerDetailFilter.Action {}
