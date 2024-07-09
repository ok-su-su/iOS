//
//  SingleSelectButtonReducer.swift
//  SSEditSingleSelectButton
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Foundation

@Reducer
public struct SingleSelectButtonReducer<Item: SingleSelectButtonItemable> {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var initialValue: String = ""
    @Shared var singleSelectButtonHelper: SingleSelectButtonProperty<Item>
    var customTextFieldText: String

    @available(*, deprecated, renamed: "init(SingleSelectButtonProperty:String:)", message: "use Anohter InitialValue")
    public init(singleSelectButtonHelper: Shared<SingleSelectButtonProperty<Item>>) {
      _singleSelectButtonHelper = singleSelectButtonHelper
      customTextFieldText = singleSelectButtonHelper.isCustomItem?.title.wrappedValue ?? ""
    }

    public init(singleSelectButtonHelper: Shared<SingleSelectButtonProperty<Item>>, initialValue: String?) {
      _singleSelectButtonHelper = singleSelectButtonHelper
      customTextFieldText = singleSelectButtonHelper.isCustomItem?.title.wrappedValue ?? ""
      guard let initialValue else {
        return
      }
      self.initialValue = initialValue
    }
  }

  public enum Action: Equatable {
    case onAppear(Bool)
    case tappedID(Int)
    case tappedAddCustomButton
    case changedText(String)
    case tappedCloseButton
    case tappedSaveAndEditButton
    case tappedCustomItem
    case initialValue(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        if state.singleSelectButtonHelper.isCustomItem?.title != "",
           let customItemName = state.singleSelectButtonHelper.isCustomItem?.title {
          state.singleSelectButtonHelper.saveCustomTextField(title: customItemName)
        }
        return .send(.initialValue(state.initialValue))
      case let .tappedID(id):
        state.singleSelectButtonHelper.selectItem(by: id)
        return .none

      case .tappedAddCustomButton:
        state.singleSelectButtonHelper.startAddCustomSection()
        return .none

      case let .changedText(text):
        state.customTextFieldText = text
        return .none

      case .tappedCloseButton:
        if state.singleSelectButtonHelper.isSaved || state.customTextFieldText == "" {
          state.singleSelectButtonHelper.resetCustomTextField()
          return .none
        }
        return .send(.changedText(""))

      case .tappedSaveAndEditButton:
        if state.singleSelectButtonHelper.isSaved {
          state.singleSelectButtonHelper.editCustomSection()
        } else {
          state.singleSelectButtonHelper.saveCustomTextField(title: state.customTextFieldText)
        }
        return .none
      case .tappedCustomItem:
        state.singleSelectButtonHelper.selectedCustomItem()
        return .none

      case let .initialValue(text):
        // DefaultItem인 경우
        if let firstItem = state.singleSelectButtonHelper.items.first(where: { $0.title == text }) {
          return .send(.tappedID(firstItem.id))
        }

        state.singleSelectButtonHelper.makeAndSelectedCustomItem(title: text)
        return .none
      }
    }
  }

  public init() {}
}
