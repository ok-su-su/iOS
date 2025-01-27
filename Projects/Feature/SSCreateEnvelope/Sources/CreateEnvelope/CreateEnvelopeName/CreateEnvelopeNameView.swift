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

// MARK: - CreateEnvelopeNameView

public struct CreateEnvelopeNameView: View {
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
      LazyVStack(spacing: 0) {
        ForEach(0 ..< filteredPrevEnvelopes.count, id: \.self) { ind in
          makeSearchFriendView(filteredPrevEnvelopes[ind])
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  @ViewBuilder
  private func makeSearchFriendView(_ current: SearchFriendItem) -> some View {
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
    .padding(.horizontal, 24)
    .padding(.vertical, 12)
    .contentShape(Rectangle())
    .onTapGesture {
      store.send(.view(.tappedFilterItem(name: current.name)))
    }
  }

  @State private var currentTextFieldText: String = ""
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
        .padding(.horizontal, Metrics.horizontalSpacing)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      TextField(
        "",
        text: $currentTextFieldText,
//        text: $store.textFieldText.sending(\.view.changeText),
        prompt: Text("이름을 입력해 주세요").foregroundStyle(SSColor.gray30),
        axis: .vertical
      )

      .onReturnKeyPressed(textFieldText: store.textFieldText) { text in
        isFocused = false
        store.sendViewAction(.changeText(text))
      }
      .submitLabel(.done)
      .onChange(of: currentTextFieldText) { _, newValue in

        currentTextFieldText = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        store.sendViewAction(.changeText(currentTextFieldText))
      }
      .foregroundStyle(SSColor.gray100)
      .modifier(SSTypoModifier(.title_xl))
      .focused($isFocused)
      .padding(.horizontal, Metrics.horizontalSpacing)

      Spacer()
        .frame(height: 24)

      makeFilteredView()
    }
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .whenTapDismissKeyboard()
      makeContentView()
        .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    }
    .nextButton(store.isPushable) {
      store.sendViewAction(.tappedNextButton)
    }
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
