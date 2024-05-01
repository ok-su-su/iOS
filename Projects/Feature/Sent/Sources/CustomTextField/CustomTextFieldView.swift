//
//  CustomTextFieldView.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CustomTextFieldView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CustomTextField>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage
        .commonSearch

      Spacer()
        .frame(width: 8)

      TextField("", text: $store.text, prompt: Constants.prompt)
        .modifier(SSTypoModifier(.text_xxs))
        .frame(maxWidth: .infinity)
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(width: 8)

      if store.state.text != "" {
        SSImage
          .commonClose
          .onTapGesture {
            store.send(.closeButtonTapped)
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
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let prompt = Text("찾고 싶은 봉투를 검색해보세요")
  }
}
