//
//  LedgerDetailEditView.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
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
    VStack(spacing: 0) {}
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
        .foregroundStyle(SSColor.gray70)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeEventEditableSection() -> some View {
    TitleAndItemsWithSingleSelectButtonView(store: store.scope(state: \.eventSection, action: \.scope.eventSection))
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

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
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
