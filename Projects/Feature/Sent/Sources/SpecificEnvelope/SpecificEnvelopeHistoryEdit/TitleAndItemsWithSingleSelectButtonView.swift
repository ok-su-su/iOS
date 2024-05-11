//
//  TitleAndItemsWithSingleSellectButtonView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct TitleAndItemsWithSingleSelectButtonView<Item: SingleSelectButtonItemable>: View {
  // MARK: Reducer

  var ssButtonFrame: SSButtonProperty.SSButtonFrame? = nil

  @Bindable
  var store: StoreOf<TitleAndItemsWithSingleSelectButton<Item>>
  init(store: StoreOf<TitleAndItemsWithSingleSelectButton<Item>>, ssButtonFrame: SSButtonProperty.SSButtonFrame? = nil) {
    self.store = store
    self.ssButtonFrame = ssButtonFrame
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .top, spacing: 16) {
      Text(store.singleSelectButtonHelper.titleText)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .topLeading)
        .foregroundStyle(SSColor.gray70)

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        // MARK: - Defaults Item

        let items = store.singleSelectButtonHelper.items
        ForEach(items) { item in
          SSButton(
            .init(
              size: .sh32,
              status: item == store.singleSelectButtonHelper.selectedItem ? .active : .inactive,
              style: .filled,
              color: .orange,
              buttonText: item.title,
              frame: ssButtonFrame
            )) {
              store.send(.tappedID(item.id))
            }
        }

        // 만약 CustomItem을 추가할 수 있을 떄
        if let customItem = store.singleSelectButtonHelper.isCustomItem {
          if store.singleSelectButtonHelper.isStartedAddingNewCustomItem || store.singleSelectButtonHelper.isSaved { // CustomText Field Button
            SSTextFieldButton(
              .init(
                size: .sh32,
                status: store.singleSelectButtonHelper.isSaved ? .saved : .filled,
                style: .filled,
                color: store.singleSelectButtonHelper.selectedItem == customItem ? .orange : .gray,
                textFieldText: $store.customTextFieldText.sending(\.changedText),
                showCloseButton: true,
                showDeleteButton: true,
                prompt: store.singleSelectButtonHelper.customTextFieldPrompt ?? ""
              )) {
                store.send(.tappedCustomItem)
              } onTapCloseButton: {
                store.send(.tappedCloseButton)
              } onTapSaveButton: {
                store.send(.tappedSaveAndEditButton)
              }

          } else { // + add Button
            Button {
              store.send(.tappedAddCustomButton)
            } label: {
              SSImage
                .commonAdd
            }
            .padding(.all, 4)
            .background(SSColor.gray70)
            .clipShape(RoundedRectangle(cornerRadius: 4))
          }
        }
      }
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  var body: some View {
    makeContentView()
      .onAppear {
        store.send(.onAppear(true))
      }
  }
}
