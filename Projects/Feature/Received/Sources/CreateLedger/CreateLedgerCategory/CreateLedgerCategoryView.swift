//
//  CreateLedgerCategoryView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSSelectableItems
import SSToast
import SwiftUI

struct CreateLedgerCategoryView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateLedgerCategory>

  // MARK: Init

  init(store: StoreOf<CreateLedgerCategory>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 32) {
        Text("어떤 경조사였나요?")
          .foregroundStyle(SSColor.gray100)
          .modifier(SSTypoModifier(.title_m))
        SSSelectableItemsView(store: store.scope(state: \.selection, action: \.scope.selection))
          .padding(.bottom, 24)
      }
      .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  private func nextButton() -> some View {
    BottomNextButtonView(titleText: "다음", isActive: store.isPushable) {
      store.sendViewAction(.tappedNextButton)
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        makeContentView()
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .safeAreaInset(edge: .bottom) {
      nextButton()
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
