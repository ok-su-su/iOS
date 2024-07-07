//
//  LedgerDetailEditView.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEditSingleSelectButton
import SwiftUI

struct LedgerDetailEditView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LedgerDetailEdit>

  // MARK: Init

  init(store: StoreOf<LedgerDetailEdit>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeNameEditableSection()

      makeEventEditableSection()

      makeDateEditableSection()
    }
  }

  @ViewBuilder
  private func makeNameEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text("경조사 명")
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      TextField("", text: $store.editProperty.nameEditProperty.textFieldText.sending(\.view.changeNameTextField), prompt: nil)
        .frame(maxWidth: .infinity)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray70)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }

  @ViewBuilder
  private func makeEventEditableSection() -> some View {
    SingleSelectButtonView(store: store.scope(state: \.categorySection, action: \.scope.categorySection))
      .padding(.vertical, 16)
  }

  @ViewBuilder
  private func makeDateEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text("날짜")
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      Text(store.editProperty.dateEditProperty.startDate.description)
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray100)
        .onTapGesture {
          // TODO: - Date Picker Dial
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, 16)
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
