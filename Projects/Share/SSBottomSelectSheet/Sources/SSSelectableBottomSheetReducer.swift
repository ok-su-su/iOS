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
public struct SSSelectableBottomSheetReducer<Item: SSSelectBottomSheetPropertyItemable> {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false

    var items: [Item]
    @Shared var selectedItem: Item?
    public init(items: [Item], selectedItem: Shared<Item?>) {
      self.items = items
      _selectedItem = selectedItem
    }
  }

  public enum Action: Equatable {
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
        state.selectedItem = item
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

public typealias SSSelectBottomSheetPropertyItemable = CustomStringConvertible & Equatable & Identifiable
