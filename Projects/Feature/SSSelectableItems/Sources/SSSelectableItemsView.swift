//
//  SSSelectableItemsView.swift
//  SSSelectableItems
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SSSelectableItemsView<Item: SSSelectableItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SSSelectableItemsReducer<Item>>

  public init(store: StoreOf<SSSelectableItemsReducer<Item>>) {
    self.store = store
  }

  // MARK: Content

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      makeDefaultItems()
      if store.isCustomItem != nil {
        makeCustomItem()
      }
    }
  }

  @ViewBuilder
  private func makeDefaultItems() -> some View {
    ForEach(store.items) { item in
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: store.selectedID.contains(item.id) ? .filled : .ghost,
          color: store.selectedID.contains(item.id) ? .orange : .black,
          buttonText: item.title,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedItem(id: item.id)))
        }
    }
  }

  @ViewBuilder
  /// 만약 커스텀 아이템이 존재 하면
  private func makeCustomItem() -> some View {
    // CustomItem을 Edit하는 상황이면
    if store.isAddingNewItem,
       let item = store.isCustomItem {
      SSTextFieldButton(
        .init(
          size: .mh60,
          status: store.customItemSaved ? .saved : .filled,
          style: .filled,
          color: store.selectedID.contains(item.id) ? .orange : .black,
          textFieldText: $store.customTitleText.sending(\.view.changeTextField),
          showCloseButton: true,
          showDeleteButton: true,
          prompt: Constants.addNewRelationTextFieldPrompt,
          regex: store.regex
        )) {
          if store.customItemSaved {
            store.send(.view(.tappedItem(id: item.id)))
          }
        } onTapCloseButton: {
          store.send(.view(.tappedTextFieldCloseButton))
        } onTapSaveButton: {
          store.send(.view(.tappedTextFieldSaveAndEditButton))
        }
    } else {
      // 만약 커스텀 아이템이 존재하면서, EmptyState일 때
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: .ghost,
          color: .black,
          buttonText: Constants.makeAddCustomRelationButtonText,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedAddCustomTextField))
        }
    }
  }

  private enum Metrics {}

  private enum Constants {
    static var makeAddCustomRelationButtonText: String { "직접 입력" }
    static var addNewRelationTextFieldPrompt: String { "입력해주세요" }
  }
}
