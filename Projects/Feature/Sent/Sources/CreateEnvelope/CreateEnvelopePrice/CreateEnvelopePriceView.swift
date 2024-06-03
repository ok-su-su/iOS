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
import SwiftUI

// MARK: - CreateEnvelopePriceView

struct CreateEnvelopePriceView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopePrice>

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

      SSTextField(isDisplay: true, text: $store.textFieldText, property: .amount, isHighlight: $store.textFieldIsHighlight)
        .onChange(of: store.textFieldText) { oldValue, newValue in
          if oldValue == newValue {
            return
          }
          store.send(.view(.changeText(newValue)))
        }

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
