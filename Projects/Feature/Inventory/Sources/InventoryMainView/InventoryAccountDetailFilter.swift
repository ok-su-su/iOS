//
//  InventoryAccountDetailFilter.swift
//  Inventory
//
//  Created by Kim dohyun on 5/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Designsystem

// MARK: - InventoryAccountDetailFilter

@Reducer
public struct InventoryAccountDetailFilter {
  @ObservableState
  public struct State {
    var headerType = HeaderViewFeature.State(.init(title: "필터", type: .depth2Default))
    var accountSearchTextField: InventoryAccountDetailFilterTextField.State

    @Shared var textFieldText: String
    @Shared var accountFilterHelper: InventoryAccountFilterHelper

    init(accountFilterHelper: Shared<InventoryAccountFilterHelper>) {
      _accountFilterHelper = accountFilterHelper
      _textFieldText = .init("")
      accountSearchTextField = .init(text: _textFieldText)

      self.accountFilterHelper.fakeEntity()
    }
  }

  @Dependency(\.dismiss) var dismiss

  public enum Action: Equatable {
    case header(HeaderViewFeature.Action)
    case detailTextField(InventoryAccountDetailFilterTextField.Action)
    case didTapPerson(UUID)
    case didTapSelectedPerson(UUID)
    case reset
    case didTapConfirmButton
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.headerType, action: \.header) {
      HeaderViewFeature()
    }

    Scope(state: \.accountSearchTextField, action: \.detailTextField) {
      InventoryAccountDetailFilterTextField()
    }

    Reduce { state, action in
      switch action {
      case .reset:
        state.accountFilterHelper.reset()
        return .none
      case let .didTapPerson(index):
        state.accountFilterHelper.select(selectedId: index)
        return .none
      case let .didTapSelectedPerson(index):
        state.accountFilterHelper.select(selectedId: index)
        return .none
      case .didTapConfirmButton:
        return .run { _ in await dismiss() }
      default:
        return .none
      }
    }
  }
}
