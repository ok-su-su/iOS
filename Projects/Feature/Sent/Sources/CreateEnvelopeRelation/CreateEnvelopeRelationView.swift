//
//  CreateEnvelopeRelationView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeRelationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRelation>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)
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
          style: store.selectedRelationString == current ? .filled : .ghost,
          color: store.selectedRelationString == current ? .orange : .black,
          buttonText: current,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedRelation(name: current)))
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
          style: store.selectedRelationString == current ? .filled : .ghost,
          color: store.selectedRelationString == current ? .orange : .black,
          buttonText: current,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedRelation(name: current)))
        }
    }
  }

  @ViewBuilder
  private func makeAddCustomRelationButton() -> some View {
    ZStack {
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: .ghost,
          color: .black,
          buttonText: store.isAddingNewRelation ? "" : Constants.makeAddCustomRelationButtonText,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedAddCustomRelation))
        }
      if store.isAddingNewRelation {
        HStack(spacing: 8) {
          Spacer()
            .frame(width: 24)

          TextField(
            "",
            text: $store.addingCustomRelationText,
            prompt: Constants.addNewRelationTextFieldPromptText as? Text
          )
          .frame(maxWidth: .infinity)

          Button {
            store.send(.view(.tappedDeleteCurrentAddingRelation))
          } label: {
            SSImage.commonClose
          }

          // TODO: add new TextFieldButton
          Button {
            store.send(.view(.tappedSaveCurrentAddingRelation))
          } label: {
            Text("저장")
              .modifier(SSTypoModifier(.title_xxs))
              .foregroundStyle(SSColor.gray10)
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(Color(red: 0.14, green: 0.14, blue: 0.14))
          .cornerRadius(4)

          Spacer()
            .frame(width: 16)
        }
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
        makeRelationButton()
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
    static let titleText: String = "나와는\n어떤 사이 인가요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
    static let addNewRelationTextFieldPromptText: some View = Text(Constants.addNewRelationTextFieldPrompt)
      .modifier(SSTypoModifier(.title_xs))
      .foregroundStyle(SSColor.gray30)
  }
}
