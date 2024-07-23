//
//  SelectBottomSheet.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - SelectBottomSheet

@Reducer
struct SelectBottomSheet<Item: SelectBottomSheetPropertyItemable> {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var property: SelectBottomSheetProperty<Item>
    init(property: Shared<SelectBottomSheetProperty<Item>>) {
      _property = property
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tappedItem(item: Item)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case let .tappedItem(item: item):
        return .run { _ in
          await dismiss()
        }
      }
    }
  }
}

// MARK: - SelectBottomSheetProperty

typealias SelectBottomSheetPropertyItemable = CustomStringConvertible & Equatable & Identifiable

// MARK: - SelectBottomSheetProperty

struct SelectBottomSheetProperty<Item: SelectBottomSheetPropertyItemable>: Equatable {
  let items: [Item]
  init(items: [Item]) {
    self.items = items
  }
}
