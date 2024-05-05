//
//  CreateEnvelopeNameView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeNameView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeName>

  // MARK: Content

  @ViewBuilder
  private func makeFilteredView() -> some View {
    VStack {
      let filteredPrevEnvelopes = store.filteredPrevEnvelopes
      ForEach(0 ..< filteredPrevEnvelopes.count, id: \.self) { ind in
        let current = filteredPrevEnvelopes[ind]
        HStack(alignment: .top, spacing: 8) {
          Text(current.name)
            .modifier(SSTypoModifier(.title_xs))
            .foregroundStyle(SSColor.gray100)

          Text(current.relationShip)
            .modifier(SSTypoModifier(.title_xs))
            .foregroundStyle(SSColor.gray60)

          Text(current.eventName)
            .modifier(SSTypoModifier(.text_xs))
            .foregroundStyle(SSColor.gray40)

          Text(current.eventDate.description)
            .modifier(SSTypoModifier(.text_xs))
            .foregroundStyle(SSColor.gray40)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 4))
      }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      SSTextField(isDisplay: true, text: $store.textFieldText, property: .account, isHighlight: $store.textFieldIsHighlight)
      Spacer()
        .frame(height: 24)

      makeFilteredView()
      Spacer()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    SSButton(
      .init(
        size: .mh60,
        status: store.isAbleToPush ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {}
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
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
    static let titleText: String = "누구에게 보냈나요?"
  }
}
