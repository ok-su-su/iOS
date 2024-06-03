//
//  InvetoryAccountDetailFilterTextFieldView.swift
//  Inventory
//
//  Created by Kim dohyun on 6/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

struct InvetoryAccountDetailFilterTextFieldView: View {
  @Bindable var store: StoreOf<InventoryAccountDetailFilterTextField>

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

      if store.text != "" {
        SSImage
          .commonClose
          .onTapGesture {
            store.send(.didTapCloseButton)
          }
      }
    }
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

  private enum Constants {
    static let prompt = Text("보낸 사람을 검색해보세요")
  }
}
