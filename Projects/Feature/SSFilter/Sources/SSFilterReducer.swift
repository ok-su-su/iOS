//
//  SSFilter.swift
//  SSfilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
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
    var sliderReducer: SSFilterWithSliderReducer.State? = nil
    var isSearchSection: Bool
    let type: InitialType

    var filterByTextField: [Item] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return ssFilterItemHelper.selectableItems.filter { $0.title.contains(regex) }
    }

    public init(type: InitialType, isSearchSection: Bool) {
      self.isSearchSection = isSearchSection
      self.type = type
      switch type {
      case .withDate:
        dateReducer = .init()
      case let .withSlider(titleLabel):
        sliderReducer = .init(titleLabel: titleLabel)
      }
    }

    public enum InitialType: Sendable, Equatable {
      case withDate
      case withSlider(titleLabel: String)
    }
  }

  public enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
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
    case updateSliderMaximumValue(Int64)
    case updatePrevSelectedFilteredItemsAndSlider(item: [Item], minimumValue: Int64?, maximumValue: Int64?)
    case updatePrevSelectedFilterItemsAndDate(item: [Item], startDate: Date?, endDate: Date?)
  }

  public enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case dateReducer(SSFilterWithDateReducer.Action)
    case sliderReducer(SSFilterWithSliderReducer.Action)
  }

  public enum DelegateAction: Equatable, Sendable {
    case changeTextField(String)
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
    case .withSlider:
      let sliderProperty = state.sliderReducer?.sliderProperty
      let isInitialStateOfSlider = sliderProperty?.isInitialState
      return .send(
        .delegate(
          .tappedConfirmButtonWithSliderProperty(
            selectedItems: selectedItems,
            minimumValue: isInitialStateOfSlider == true ? nil : sliderProperty?.minimumTextValue,
            maximumValue: isInitialStateOfSlider == true ? nil : sliderProperty?.maximumTextValue
          )
        )
      )
    }
  }

  private func onAppearEffect(_ state: State) -> Effect<Action> {
    let dateReducerAction: Effect<Action> = state.dateReducer == nil ? .none :
      .send(.scope(.dateReducer(.view(.onAppear(true)))))
    let sliderReducerAction: Effect<Action> = state.sliderReducer == nil ? .none :
      .send(.scope(.sliderReducer(.view(.onAppear(true)))))
    return .merge(
      dateReducerAction,
      sliderReducerAction
    )
  }

  public func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return onAppearEffect(state)

    case let .tappedItem(item):
      state.ssFilterItemHelper.select(item.id)
      return .none

    case let .changeTextField(text):
      state.textFieldText = text
      return .send(.delegate(.changeTextField(text)))

    case .closeButtonTapped:
      state.textFieldText = ""
      return .none

    case .tappedConfirmButton:
      return confirmButtonAction(&state)

    case .reset:
      state.ssFilterItemHelper.reset()
      state.dateReducer?.dateProperty.resetDate()
      state.sliderReducer?.sliderProperty.reset()
      return .none
    }
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateItems(item):
      state.ssFilterItemHelper.selectableItems = (state.ssFilterItemHelper.selectableItems + item).uniqued()
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateSliderMaximumValue(value):
      state.sliderReducer?.sliderProperty.updateSliderMaximumValue(value)
      return .none

    case let .updatePrevSelectedFilteredItemsAndSlider(items, minimumValue, maximumValue):
      state.ssFilterItemHelper.selectedItems = items
      state.sliderReducer?.sliderProperty.updateSliderPrevValue(
        minimumValue: minimumValue,
        maximumValue: maximumValue
      )
      return .none

    case let .updatePrevSelectedFilterItemsAndDate(items, startDate, endDate):
      state.ssFilterItemHelper.selectedItems = items
      state.dateReducer?.dateProperty.updateDateOf(startDate: startDate, endDate: endDate)
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
    .ifLet(\.sliderReducer, action: \.scope.sliderReducer) {
      SSFilterWithSliderReducer()
    }
  }
}
