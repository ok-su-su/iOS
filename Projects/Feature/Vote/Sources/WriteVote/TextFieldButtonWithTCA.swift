//
//  TextFieldButtonWithTCA.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - TextFieldButtonWithTCA

@Reducer
struct TextFieldButtonWithTCA<Item: TextFieldButtonWithTCAPropertiable> {
  @ObservableState
  struct State: Equatable, Identifiable {
    @Shared var item: Item
    var isOnAppear: Bool = false

    var id: Int {
      return item.id
    }

    init(sharedItem: Shared<Item>) {
      _item = sharedItem
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case changedTextfield(String)
    case tappedCloseButton
    case tappedSavedAndEditButton
    case tappedTextFieldButton
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case let .changedTextfield(text):
        state.item.title = text
        return .none
      case .tappedCloseButton:
        return .none
      case .tappedSavedAndEditButton:
        return .none
      case .tappedTextFieldButton:
        return .none
      }
    }
  }
}

// MARK: - TextFieldButtonWithTCAPropertiable

protocol TextFieldButtonWithTCAPropertiable: Identifiable, Equatable {
  var id: Int { get }
  var title: String { get set }
  var isSaved: Bool { get set }
  var isEditing: Bool { get set }

  mutating func deleteTextFieldText()
  mutating func deleteTextField()
  mutating func savedTextField()
  mutating func editTextField(text: String)
}
