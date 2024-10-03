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
    fileprivate var initialSelectedID: Item.ID?
    @Shared var singleSelectButtonHelper: SingleSelectButtonProperty<Item>
    var customTextFieldText: String

    public init(singleSelectButtonHelper: Shared<SingleSelectButtonProperty<Item>>) {
      _singleSelectButtonHelper = singleSelectButtonHelper
      customTextFieldText = ""
      initialSelectedID = singleSelectButtonHelper.wrappedValue.initialSelectedID
      setCustomTextField()
    }

    private mutating func setCustomTextField() {
      if initialSelectedID == singleSelectButtonHelper.isCustomItem?.id {
        customTextFieldText = singleSelectButtonHelper.isCustomItem?.title ?? ""
        singleSelectButtonHelper.saveCustomTextField(title: customTextFieldText)
      }
    }
  }

  public enum Action: Equatable {
    case onAppear(Bool)
    case tappedID(Item.ID?)
    case tappedAddCustomButton
    case changedText(String)
    case tappedCloseButton
    case tappedSaveAndEditButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .send(.tappedID(state.initialSelectedID))

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
      }
    }
  }

  public init() {}
}
