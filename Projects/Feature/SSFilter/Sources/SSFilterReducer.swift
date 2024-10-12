//
//  SSFilter.swift
//  SSfilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSBottomSelectSheet

@Reducer
public struct SSFilterReducer<Item: SSFilterItemable>: Sendable {
  public init() {}

  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    var isLoading: Bool = true
    var textFieldText: String = ""
    var ssFilterItemHelper: SSFilterItemHelper<Item> = .init(selectableItems: [], selectedItems: [])
    var dateReducer: SSFilterWithDateReducer.State? = nil
    let type: InitialType
    init(type: InitialType) {
      self.type = type
      switch type {
      case .withDate:
        dateReducer = .init()
      case .withSlide:
        break
      }
    }

    enum InitialType {
      case withDate
      case withSlide
    }
  }

  public enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedItem(Item)
    case changeTextField(String)
    case closeButtonTapped
    case tappedConfirmButton
    case reset
  }

  public enum InnerAction: Equatable, Sendable {
    case updateItems([Item])
    case isLoading(Bool)
  }

  public enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case dateReducer(SSFilterWithDateReducer.Action)
  }

  public enum DelegateAction: Equatable, Sendable {
    case tappedConfirmButtonWithSliderProperty(selectedItems: [Item], minimumValue: Int64?, maximumValue: Int64?)
    case tappedConfirmButtonWithDateProperty(selectedItems: [Item], startDate: Date?, endDate: Date?)
  }

  private func confirmButtonAction(_ state: inout State) -> Effect<Action> {
    let selectedItems = state.ssFilterItemHelper.selectedItems
    switch state.type {
    case .withDate:
      let dateProperty = state.dateReducer?.dateProperty
      return .send(
        .delegate(
          .tappedConfirmButtonWithDateProperty(
            selectedItems: selectedItems,
            startDate: dateProperty?.isInitialStateOfStartDate == true ? nil : dateProperty?.startDate,
            endDate: dateProperty?.isInitialStateOfEndDate == true ? nil : dateProperty?.endDate
          )
        )
      )
    case .withSlide:
      return .send(
        .delegate(
          .tappedConfirmButtonWithSliderProperty(
            selectedItems: selectedItems,
            minimumValue: <#T##Int64#>,
            maximumValue: <#T##Int64#>
          )
        )
      )
    }
  }

  public func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case let .tappedItem(item):
      state.ssFilterItemHelper.select(item.id)
      return .none

    case let .changeTextField(text):
      state.textFieldText = text
      return .none

    case .closeButtonTapped:
      state.textFieldText = ""
      return .none

    case .tappedConfirmButton:
      let selectedItems = state.ssFilterItemHelper.selectedItems

      return .none

    case .reset:
      state.ssFilterItemHelper.reset()
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateItems(item):
      state.ssFilterItemHelper.selectableItems = item
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case .scope:
        return .none
      case .delegate:
        return .none
      }
    }
    .ifLet(\.dateReducer, action: \.scope.dateReducer) {
      SSFilterWithDateReducer()
    }
  }
}
