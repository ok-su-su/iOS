//
//  CreateEnvelopeSelectItemsView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeSelectItemsView<Item: CreateEnvelopeSelectItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeSelectItems<Item>>

  init(store: StoreOf<CreateEnvelopeSelectItems<Item>>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {}

  var body: some View {
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
  private func makeCustomItem() -> some View {
    if
      store.isAddingNewItem,
      let item = store.isCustomItem {
      SSTextFieldButton(
        .init(
          size: .mh60,
          status: store.customItemSaved ? .saved : .filled,
          style: .filled,
          color: store.selectedID.contains(item.id) ? .orange : .black,
          textFieldText: $store.customTitleText,
          showCloseButton: true,
          showDeleteButton: true,
          prompt: Constants.addNewRelationTextFieldPrompt
        )) {
          store.send(.view(.tappedItem(id: item.id)))
        } onTapCloseButton: {
          store.send(.view(.tappedTextFieldCloseButton))
        } onTapSaveButton: {
          store.send(.view(.tappedTextFieldSaveAndEditButton))
        }
    } else {
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: .ghost,
          color: .black,
          buttonText: Constants.makeAddCustomRelationButtonText,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedAddCustomRelation))
        }
    }
  }

  private enum Metrics {}

  private enum Constants {
    static var makeAddCustomRelationButtonText: String { "직접 입력" }
    static var addNewRelationTextFieldPrompt: String { "입력해주세요" }
  }
}
