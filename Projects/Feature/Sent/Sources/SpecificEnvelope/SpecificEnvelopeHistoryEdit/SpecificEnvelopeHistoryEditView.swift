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
      // Title
      Text(store.editHelper.envelopeDetailProperty.priceText)
        .modifier(SSTypoModifier(.title_xxl))
        .foregroundStyle(SSColor.gray100)

      makeSubContents()
    }
    Spacer()
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

      TextField("", text: $store.editHelper.nameEditProperty.textFieldText.sending(\.view.textFieldChanged), prompt: nil)
        .frame(maxWidth: .infinity)
        .modifier(SSTypoModifier(.title_s))
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
        .frame(maxWidth: .infinity)
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

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
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
