//
//  CreateEnvelopeEventView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSSelectableItems
import SSToast
import SwiftUI

public struct CreateEnvelopeCategoryView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeCategory>

  public init(store: StoreOf<CreateEnvelopeCategory>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 24)

      makeTitleAndButtonView()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeTitleAndButtonView() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 34) {
          Text(Constants.titleText)
            .modifier(SSTypoModifier(.title_m))
            .foregroundStyle(SSColor.gray100)

          makeItem()
        }
        Spacer()
          .frame(height: Metrics.bottomSpacing)
      }
    }
    .scrollIndicators(.hidden)
    .contentShape(Rectangle())
    .whenTapDismissKeyboard()
    .scrollBounceBehavior(.basedOnSize)
  }

  @ViewBuilder
  private func makeItem() -> some View {
    SSSelectableItemsView(store: store.scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems))
      .modifier(SSLoadingModifier(isLoading: store.isLoading))
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      makeContentView()
        .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
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
    static let bottomSpacing: CGFloat = 32
  }

  private enum Constants {
    static let titleText: String = "어떤 경조사였나요"
    static let makeAddCustomRelationButtonText = "직접 입력"
    static let addNewRelationTextFieldPrompt = "입력해주세요"
  }
}
