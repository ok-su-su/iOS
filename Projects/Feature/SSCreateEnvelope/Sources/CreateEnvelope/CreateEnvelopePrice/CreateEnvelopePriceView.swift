//
//  CreateEnvelopePriceView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SSLayout
import SSToast
import SwiftUI
import UIKit

// MARK: - CreateEnvelopePriceView

struct CreateEnvelopePriceView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopePrice>

  @FocusState
  var isFocused: Bool

  // MARK: Content

  @ViewBuilder
  private func makeTextFieldWrapperView() -> some View {
    // Visiable TextField
    let currentText = store.wrappedText + "원"
    Text(store.textFieldText.isEmpty ? "금액을 입력해 주세요" : currentText)
      .multilineTextAlignment(.leading)
      .modifier(SSTypoModifier(.title_xl))
      .foregroundStyle(store.textFieldText.isEmpty ? SSColor.gray30 : SSColor.gray100)
      .frame(alignment: .leading)
      .background(SSColor.gray15)
      .onTapGesture {
        isFocused = true
      }
  }

  // TODO: TextField어떻게 만들었는지 Trouble shooting 글 작성
  @ViewBuilder
  private func makeTextField() -> some View {
    ZStack(alignment: .topLeading) {
      // invisiableTextField
      TextField(
        "",
        text: $store.textFieldText.sending(\.view.changeText),
        prompt: nil,
        axis: .vertical
      )
      .tint(.clear)
      .foregroundStyle(Color.clear)
      .keyboardType(.numberPad)
      .modifier(SSTypoModifier(.title_xl))
      .focused($isFocused)
      .onChange(of: isFocused) { _, newValue in
        store.isFocused = newValue
      }
      .onChange(of: store.isFocused) { _, newValue in
        isFocused = newValue
      }
      // wrapping View
      makeTextFieldWrapperView()
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    let titleText = store.createType == .sent ? Constants.sentTitleText : Constants.receivedTitleText
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      makeTextField()
      Spacer()
        .frame(height: 32)

      // MARK: - Price Guid View

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(store.guidPrices, id: \.self) { price in
          let item = CustomNumberFormatter.formattedByThreeZero(price)
          SSButton(
            .init(
              size: .sh32,
              status: .active,
              style: .filled,
              color: .orange,
              buttonText: "\(item ?? price.description)원"
            )
          ) {
            store.sendViewAction(.tappedGuidValue(price))
          }
        }
      }

      Spacer()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(alignment: .leading) {
        makeContentView()
      }
      .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    }
    .nextButton(store.isAbleToPush) {
      store.sendViewAction(.tappedNextButton)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let sentTitleText: String = "얼마를 보냈나요?"
    static let receivedTitleText: String = "얼마를 받았나요?"
  }
}
