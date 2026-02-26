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
public struct SingleSelectButtonReducer<Item: SingleSelectButtonItemable>: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
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
      var initialTitle: String?
      $singleSelectButtonHelper.withLock { helper in
        if initialSelectedID == helper.isCustomItem?.id {
          initialTitle = helper.isCustomItem?.title ?? ""
          helper.saveInitialCustomTextField(title: initialTitle ?? "")
        }
      }
      if let initialTitle {
        customTextFieldText = initialTitle
      }
    }
  }

  /// uncheckedSendable because of Identifiable
  public enum Action: Equatable, Sendable {
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
        return .none

      case let .tappedID(id):
        state.$singleSelectButtonHelper.withLock { $0.selectItem(by: id) }
        return .none

      case .tappedAddCustomButton:
        state.$singleSelectButtonHelper.withLock { $0.startAddCustomSection() }
        return .none

      case let .changedText(text):
        state.customTextFieldText = text
        return .none

      case .tappedCloseButton:
        if state.singleSelectButtonHelper.isSaved || state.customTextFieldText == "" {
          state.$singleSelectButtonHelper.withLock { $0.resetCustomTextField() }
          return .none
        }
        return .send(.changedText(""))

      case .tappedSaveAndEditButton:
        if state.singleSelectButtonHelper.isSaved {
          state.$singleSelectButtonHelper.withLock { $0.editCustomSection() }
        } else {
          state.$singleSelectButtonHelper.withLock { $0.saveCustomTextField(title: state.customTextFieldText) }
        }
        return .none
      }
    }
  }

  public init() {}
}
