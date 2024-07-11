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

  @FocusState
  var isFocused

  @Bindable
  var store: StoreOf<CreateEnvelopeName>

  // MARK: Content

  @ViewBuilder
  private func makeFilteredView() -> some View {
    ScrollView(.vertical) {
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

          if let eventName = current.eventName {
            Text(eventName)
              .modifier(SSTypoModifier(.text_xs))
              .foregroundStyle(SSColor.gray40)
          }

          if let eventDate = current.eventDate {
            Text(CustomDateFormatter.getString(from: eventDate, dateFormat: "yyyy.MM.dd"))
              .modifier(SSTypoModifier(.text_xs))
              .foregroundStyle(SSColor.gray40)
          }

          Spacer()
        }
        .onTapGesture {
          store.send(.view(.tappedFilterItem(name: current.name)))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 4))
      }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    let titleText = store.createType == .sent ? Constants.sentTitleText : Constants.receivedTitleText
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      TextField(
        "",
        text: $store.textFieldText.sending(\.view.changeText),
        prompt: Text("이름을 입력해 주세요").foregroundStyle(SSColor.gray30),
        axis: .vertical
      )
      .onReturnKeyPressed(textFieldText: store.textFieldText) { text in
        isFocused = false
        store.sendViewAction(.changeText(text))
      }
      .submitLabel(.done)
      .foregroundStyle(SSColor.gray100)
      .modifier(SSTypoModifier(.title_xl))
      .focused($isFocused)

      Spacer()
        .frame(height: 24)

      makeFilteredView()
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
      VStack {
        makeContentView()
      }
    }
    .nextButton(store.isPushable) {
      store.sendViewAction(.tappedNextButton)
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .navigationBarBackButtonHidden()
    .onAppear {
      isFocused = true
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let sentTitleText: String = "누구에게 보냈나요?"
    static let receivedTitleText: String = "누구에게 받았나요?"
  }
}
