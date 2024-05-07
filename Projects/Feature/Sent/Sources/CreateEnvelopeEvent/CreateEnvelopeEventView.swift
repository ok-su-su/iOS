//
//  CreateEnvelopeEventView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeEventView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeEvent>

  // MARK: Content

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

      // MARK: - Buttons

      makeRelationButton()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeRelationButton() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        makeDefaultRelationButton()
        makeCustomRelationButton()
        makeAddCustomRelationButton()
      }
    }
  }

  @ViewBuilder
  private func makeDefaultRelationButton() -> some View {
    ForEach(store.defaultRelationString, id: \.self) { current in
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: store.selectedString == current ? .filled : .ghost,
          color: store.selectedString == current ? .orange : .black,
          buttonText: current,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedItem(name: current)))
        }
    }
  }

  @ViewBuilder
  private func makeCustomRelationButton() -> some View {
    ForEach(store.createEnvelopeProperty.customRelation, id: \.self) { current in
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: store.selectedString == current ? .filled : .ghost,
          color: store.selectedString == current ? .orange : .black,
          buttonText: current,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedItem(name: current)))
        }
    }
  }

  @ViewBuilder
  private func makeAddCustomRelationButton() -> some View {
    if store.isAddingNewItem {
      SSTextFieldButton(
        .init(
          size: .mh60,
          status: store.isSavedCustomItem ? .saved : .filled,
          style: .filled,
          color: store.addingCustomItemText == store.selectedString ? .orange : .black,
          textFieldText: $store.addingCustomItemText,
          showCloseButton: true,
          showDeleteButton: true,
          prompt: Constants.addNewRelationTextFieldPrompt
        )) {
          store.send(.view(.tappedItem(name: store.addingCustomItemText)))
        } onTapCloseButton: {
          store.send(.view(.tappedTextFieldCloseButton))
        } onTapSaveButton: {
          store.send(.view(.tappedTextFieldSaveAndEditButton))
        }
    } else {
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: .ghost,
          color: .black,
          buttonText: Constants.makeAddCustomRelationButtonText,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedAddCustomItemButton))
        }
    }
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
    ) {
      store.send(.view(.tappedNextButton))
    }
  }

  @ViewBuilder
  private func makeAddCustomRelation() -> some View {}

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
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .navigationBarBackButtonHidden()
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let titleText: String = "어떤 경조사였나요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
    static let addNewRelationTextFieldPromptText: some View = Text(Constants.addNewRelationTextFieldPrompt)
      .modifier(SSTypoModifier(.title_xs))
      .foregroundStyle(SSColor.gray30)
  }
}
