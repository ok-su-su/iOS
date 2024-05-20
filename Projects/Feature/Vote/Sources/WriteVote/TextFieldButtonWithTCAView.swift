//
//  TextFieldButtonWithTCAView.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct TextFieldButtonWithTCAView<Item: TextFieldButtonWithTCAPropertiable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<TextFieldButtonWithTCA<Item>>
  var prompt: String
  private let size: SSTextFieldButtonProperty.Size
  init(size: SSTextFieldButtonProperty.Size, prompt: String, store: StoreOf<TextFieldButtonWithTCA<Item>>) {
    self.size = size
    self.store = store
    self.prompt = prompt
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    SSTextFieldButton(
      .init(
        size: size,
        status: .filled,
        style: .ghost,
        color: .gray,
        textFieldText: $store.item.title.sending(\.changedTextfield),
        showCloseButton: true,
        showDeleteButton: true,
        prompt: prompt
      ),
      onTap: {
        store.send(.tappedTextFieldButton)
      }, onTapCloseButton: {}, onTapSaveButton: {}
    )
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
