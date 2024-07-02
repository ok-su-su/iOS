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

          Text(current.eventName)
            .modifier(SSTypoModifier(.text_xs))
            .foregroundStyle(SSColor.gray40)

          Text(CustomDateFormatter.getString(from: current.eventDate, dateFormat: "yyyy.MM.dd"))
            .modifier(SSTypoModifier(.text_xs))
            .foregroundStyle(SSColor.gray40)

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
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      TextField(
        "",
        text: $store.textFieldText.sending(\.view.changeText),
        prompt: Text("이름을 입력해 주세요").foregroundStyle(SSColor.gray30)
      )
      .submitLabel(.done)
      .foregroundStyle(SSColor.gray100)
      .modifier(SSTypoModifier(.title_xl))
      .focused($isFocused)
      .onChange(of: isFocused) { _, newValue in
        store.sendViewAction(.changeFocused(newValue))
      }
      .onChange(of: store.isFocused) { _, newValue in
        isFocused = newValue
      }
      .onChange(of: store.textFieldText) { _, newValue in
        store.sendViewAction(.changeText(newValue))
      }
      Spacer()
        .frame(height: 24)

      makeFilteredView()
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