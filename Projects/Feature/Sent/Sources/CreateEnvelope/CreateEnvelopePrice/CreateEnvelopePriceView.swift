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
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      ZStack {
        TextField(
          "",
          text: $store.textFieldText.sending(\.view.changeText),
          prompt: nil
        )
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

        HStack(spacing: 0) {
          Text(store.textFieldText.isEmpty ? "금액을 입력해 주세요" : store.wrappedText)
            .modifier(SSTypoModifier(.title_xl))
            .foregroundStyle(store.textFieldText.isEmpty ? SSColor.gray30 : SSColor.gray100)

          if !store.textFieldText.isEmpty {
            Text("원")
              .modifier(SSTypoModifier(.title_xl))
              .foregroundStyle(SSColor.gray100)
          }
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 46)
        .background(SSColor.gray15)
      }
      .frame(height: 44)

      Spacer()
        .frame(height: 32)

      // MARK: - Price Guid View

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(store.formattedGuidPrices, id: \.self) { item in
          SSButton(
            .init(size: .sh32, status: .active, style: .filled, color: .orange, buttonText: "\(item)원")) {
              store.send(.view(.tappedGuidValue(item)))
            }
        }
      }

      Spacer()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    CreateEnvelopeBottomOfNextButtonView(
      store: store.scope(state: \.nextButton, action: \.scope.nextButton)
    )
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()

      VStack(alignment: .leading) {
        makeContentView()
          .modifier(SSToastModifier(toastStore: store.scope(state: \.toast, action: \.scope.toast)))
        makeNextButton()
      }
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
    static let titleText: String = "얼마를 보냈나요?"
  }
}
