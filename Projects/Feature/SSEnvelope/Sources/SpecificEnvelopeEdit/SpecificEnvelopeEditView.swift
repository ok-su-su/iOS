//
//  SpecificEnvelopeEditView.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

// MARK: - SpecificEnvelopeEditView

public struct SpecificEnvelopeEditView: View {
  @FocusState
  var focus

  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeEditReducer>

  public init(store: StoreOf<SpecificEnvelopeEditReducer>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        // Price
        makePriceTextFieldView()

        makeSubContents()
      }
      .whenTapDismissKeyboard()
    }
  }

  @ViewBuilder
  private func makePriceTextFieldView() -> some View {
    ZStack {
      // invisiableTextField
      TextField(
        "",
        text: $store.editHelper.priceProperty.priceTextFieldText.sending(\.view.changePriceTextField),
        prompt: nil
      )
      .focused($focus)
      .keyboardType(.numberPad)
      .modifier(SSTypoModifier(.title_xl))

      // Visiable TextField
      HStack(spacing: 0) {
        Text(store.editHelper.priceProperty.priceText.isEmpty ? "금액을 입력해 주세요" : store.editHelper.priceProperty.priceText)
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(store.editHelper.priceProperty.priceText.isEmpty ? SSColor.gray30 : SSColor.gray100)
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: 46)
      .background(SSColor.gray15)
    }
    .frame(height: 44)
    .onTapGesture {
      focus = true
    }
  }

  @ViewBuilder
  private func makeSubContents() -> some View {
    VStack(spacing: 0) {
      // Section
      makeEventEditableSection()

      // name
      makeNameEditableSection()

      // Relation
      makeEditableRelationSection()

      // Date
      makeDateEditableSection()

      // Visited
      makeEditableVisitedSection()

      // Gift
      makeEditableGiftSection()

      // contact
      makeEditableContactSection()

      // memo
      makeEditableMemoSection()
    }
  }

  @ViewBuilder
  private func makeEventEditableSection() -> some View {
    TitleAndItemsWithSingleSelectButtonView(store: store.scope(state: \.eventSection, action: \.scope.eventSection))
      .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeNameEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(store.editHelper.envelopeDetailProperty.nameTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      TextField("", text: $store.editHelper.nameEditProperty.textFieldText.sending(\.view.changeNameTextField), prompt: nil)
        .frame(maxWidth: .infinity)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray100)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeEditableRelationSection() -> some View {
    TitleAndItemsWithSingleSelectButtonView(store: store.scope(state: \.relationSection, action: \.scope.relationSection))
      .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeDateEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(store.editHelper.envelopeDetailProperty.dateTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      Text(store.editHelper.dateEditProperty.dateText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray100)
        .onTapGesture {
          // TODO: - Date Picker Dial
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeEditableVisitedSection() -> some View {
    TitleAndItemsWithSingleSelectButtonView(
      store: store.scope(state: \.visitedSection, action: \.scope.visitedSection),
      ssButtonFrame: .init(maxWidth: 116)
    )
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeEditableGiftSection() -> some View {
    makeAdditionalSection(
      title: store.editHelper.envelopeDetailProperty.giftTitle,
      textFieldString: $store.editHelper.giftEditProperty.gift.sending(\.view.changeGiftTextField),
      promptText: "한끼 식사"
    )
  }

  @ViewBuilder
  private func makeEditableContactSection() -> some View {
    makeAdditionalSection(
      title: store.editHelper.envelopeDetailProperty.contactTitle,
      textFieldString: $store.editHelper.contactEditProperty.contact.sending(\.view.changeContactTextField),
      promptText: "01012345678"
    )
  }

  @ViewBuilder
  private func makeEditableMemoSection() -> some View {
    makeAdditionalSection(
      title: store.editHelper.envelopeDetailProperty.memoTitle,
      textFieldString: $store.editHelper.memoEditProperty.memo.sending(\.view.changeMemoTextField),
      promptText: "입력해주세요"
    )
  }

  @ViewBuilder
  func makeAdditionalSection(title: String, textFieldString: Binding<String>, promptText: String) -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(title)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(
          textFieldString.wrappedValue == "" ? SSColor.gray40 : SSColor.gray70
        )

      TextField(
        "",
        text: textFieldString,
        prompt: Text(promptText).foregroundStyle(SSColor.gray40)
      )
      .frame(maxWidth: .infinity)
      .modifier(SSTypoModifier(.title_s))
      .foregroundStyle(SSColor.gray100)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeSaveButton() -> some View {
    Button {
      store.sendViewAction(.tappedSaveButton)
    } label: {
      Text("저장")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray10)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(store.isValidToSave ? SSColor.gray100 : SSColor.gray30)
    }
    .disabled(!store.isValidToSave)
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .padding(.bottom, 16)
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .safeAreaInset(edge: .bottom) {
      makeSaveButton()
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
    static let itemVerticalSpacing: CGFloat = 16
  }

  private enum Constants {}
}
