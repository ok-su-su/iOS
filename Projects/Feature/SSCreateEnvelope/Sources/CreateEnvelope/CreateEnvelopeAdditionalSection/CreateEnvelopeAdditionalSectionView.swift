//
//  CreateEnvelopeAdditionalSectionView.swift
//  Sent
//
//  Created by MaraMincho on 5/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSSelectableItems
import SwiftUI

public struct CreateEnvelopeAdditionalSectionView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalSection>

  public init(store: StoreOf<CreateEnvelopeAdditionalSection>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      VStack(alignment: .leading, spacing: 4) {
        Text(Constants.titleText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)

        Text(Constants.descriptionText)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray70)
      }

      Spacer()
        .frame(height: 34)

      // MARK: - Buttons

      makeItems()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeItems() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        makeDefaultItems()
      }
    }
  }

  @ViewBuilder
  private func makeDefaultItems() -> some View {
    SSSelectableItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
  }

  @ViewBuilder
  private func makeAddCustomRelation() -> some View {}

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
    }
    .nextButton(store.pushable) {
      store.sendViewAction(.tappedNextButton)
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
    static let titleText: String = "더 기록할 내용이 있다면 알려주세요"
    static let descriptionText: String = "복수로 선택하셔도 좋아요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
    static let addNewRelationTextFieldPromptText: some View = Text(Constants.addNewRelationTextFieldPrompt)
      .modifier(SSTypoModifier(.title_xs))
      .foregroundStyle(SSColor.gray30)
  }
}
