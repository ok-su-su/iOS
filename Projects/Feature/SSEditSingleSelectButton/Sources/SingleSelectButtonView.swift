//
//  SingleSelectButtonView.swift
//  SSEditSingleSelectButton
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSLayout
import SwiftUI

public struct SingleSelectButtonView<Item: SingleSelectButtonItemable>: View {
  // MARK: Reducer

  var ssButtonFrame: SSButtonProperty.SSButtonFrame? = nil
  var isOneLine: Bool = false
  var titleTextColor: Color

  @Bindable
  var store: StoreOf<SingleSelectButtonReducer<Item>>
  public init(
    store: StoreOf<SingleSelectButtonReducer<Item>>,
    ssButtonFrame: SSButtonProperty.SSButtonFrame? = nil,
    isOneLine: Bool = false,
    titleTextColor: Color = SSColor.gray70
  ) {
    self.store = store
    self.ssButtonFrame = ssButtonFrame
    self.isOneLine = isOneLine
    self.titleTextColor = titleTextColor
  }

  @ViewBuilder
  private func makeOneLineView() -> some View {
    let items = store.singleSelectButtonHelper.items
    HStack(alignment: .center, spacing: 8) {
      Spacer()
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
    }
  }

  @ViewBuilder
  private func makeMultilineView() -> some View {
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
        if store.singleSelectButtonHelper.isStartedAddingNewCustomItem || store.singleSelectButtonHelper.isSaved {
          // CustomText Field Button
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
              if store.singleSelectButtonHelper.isSaved {
                store.send(.tappedID(customItem.id))
              }
            } onTapCloseButton: {
              store.send(.tappedCloseButton)
            } onTapSaveButton: {
              store.send(.tappedSaveAndEditButton)
            }

        } else { // + add Button
          SSImage
            .commonEditAdd
            .frame(width: 32, height: 32)
            .background(SSColor.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .onTapGesture {
              store.send(.tappedAddCustomButton)
            }
        }
      }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(store.singleSelectButtonHelper.titleText)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .topLeading)
        .foregroundStyle(titleTextColor)

      if isOneLine {
        makeOneLineView()
      } else {
        makeMultilineView()
      }
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  public var body: some View {
    makeContentView()
      .onAppear {
        store.send(.onAppear(true))
      }
  }
}
