//
//  SSSelectableBottomSheet.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - SSSelectableBottomSheetReducer

@Reducer
public struct SSSelectableBottomSheetReducer<Item: SSSelectBottomSheetPropertyItemable>: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false

    var items: [Item]
    @Shared fileprivate var selectedItem: Item?
    var currentSelectedItem: Item? {
      return selectedItem == nil ? deselectItem : selectedItem
    }

    var deselectItem: Item? = nil
    public init(items: [Item], selectedItem: Shared<Item?>, deselectItem: Item? = nil) {
      self.items = items
      _selectedItem = selectedItem
      self.deselectItem = deselectItem
    }
  }

  public enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case tapped(item: Item)
    case changedItem(Item)
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case let .tapped(item: item):
        let isChanged = item != state.selectedItem
        state.selectedItem = state.deselectItem == item ? nil : item
        return .run { send in
          if isChanged {
            await send(.changedItem(item))
          }
          await dismiss()
        }
      case .changedItem:
        return .none
      }
    }
  }

  public init() {}
}

// MARK: - SelectBottomSheetProperty

public typealias SSSelectBottomSheetPropertyItemable = CustomStringConvertible & Equatable & Identifiable & Sendable
