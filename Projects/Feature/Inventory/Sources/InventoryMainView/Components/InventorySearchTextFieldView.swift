//
//  InventorySearchTextFieldView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventorySearchTextFieldView

struct InventorySearchTextFieldView: View {
  @Bindable var store: StoreOf<InventorySearchTextField>

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center) {
      SSImage
        .commonSearch

      Spacer()
        .frame(width: 8)

      TextField("", text: $store.text, prompt: Constants.prompt)
        .modifier(SSTypoModifier(.text_xxs))
        .frame(maxWidth: .infinity)
        .foregroundColor(SSColor.gray100)

      Spacer()
        .frame(width: 8)

      if store.state.text != "" {
        SSImage
          .commonClose
          .onTapGesture {
            store.send(.didTapCloseButton)
          }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray20
        .ignoresSafeArea()
      makeContentView()
    }
    .frame(maxWidth: .infinity, maxHeight: 44)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}

// MARK: - Constants

private enum Constants {
  static let prompt = Text("찾고 싶은 장부를 검색해보세요")
}
