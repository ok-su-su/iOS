//
//  SpecificEnvelopeHistoryEditView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SpecificEnvelopeHistoryEditView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryEdit>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(store.editHelper.envelopeDetailProperty.priceText)
        .modifier(SSTypoModifier(.title_xxl))
        .foregroundStyle(SSColor.gray100)
      makeSubContents()
    }
    Spacer()
  }

  @ViewBuilder
  private func makeSubContents() -> some View {}

  @ViewBuilder
  private func makeTitleAndSubButtonsView(titleName: String, buttonsText: [String], tappedButton: @escaping () -> Void) -> some View {
    HStack(alignment: .top, spacing: 16) {
      Text(titleName)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72)

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(0 ..< buttonsText.count, id: \.self) { ind in
          let curButtonText = buttonsText[ind]
          SSButton(
            .init(
              size: .sh32,
              status: .inactive,
              style: .filled,
              color: .orange,
              buttonText: curButtonText
            )) {
              tappedButton()
            }
        }
      }
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
