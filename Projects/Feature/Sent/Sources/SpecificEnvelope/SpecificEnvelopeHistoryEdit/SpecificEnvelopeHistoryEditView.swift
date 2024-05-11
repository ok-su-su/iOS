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
  private func makeEventEditSection() -> some View {
    HStack(alignment: .top, spacing: 16) {
      Text(store.editHelper.envelopeDetailProperty.eventNameTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72)

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        let defaultsButtonText = store.editHelper.defaultsEventNames
        ForEach(0 ..< defaultsButtonText.count, id: \.self) { ind in
          let curButtonText = defaultsButtonText[ind]
          SSButton(
            .init(
              size: .sh32,
              status: curButtonText == store.editHelper.selectedEventName ? .active : .inactive,
              style: .filled,
              color: .orange,
              buttonText: curButtonText
            )) {
              store.send(.view(.tappedEventName(curButtonText)))
            }
        }
        Button {
          store.send(.view(.tappedEve))
        } label: {
          ZStack {
            SSColor.gray25
              
            SSImage.commonAdd
              .padding(.all, 4)
          }
          .clipShape(RoundedRectangle(cornerRadius: 4))
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
