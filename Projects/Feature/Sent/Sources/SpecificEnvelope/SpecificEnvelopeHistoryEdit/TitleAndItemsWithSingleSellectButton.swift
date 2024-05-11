//
//  TitleAndItemsWithSingleSellectButton.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct TitleAndItemsWithSingleSelectButton<Item: SingleSelectButtonItemable> {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var singleSelectButtonHelper: SingleSelectButtonHelper<Item>
    var customTextFieldText: String = ""
    init(singleSelectButtonHelper: Shared<SingleSelectButtonHelper<Item>>) {
      _singleSelectButtonHelper = singleSelectButtonHelper
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tappedID(UUID)
    case tappedAddCustomButton
    case changedText(String)
    case tappedCloseButton
    case tappedSaveAndEditButton
    case tappedCustomItem
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
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
      }
    }
  }
}
