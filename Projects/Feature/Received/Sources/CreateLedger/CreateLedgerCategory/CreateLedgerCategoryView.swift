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
    VStack(alignment: .leading, spacing: 32) {
      Text("어떤 경조사였나요?")
        .foregroundStyle(SSColor.gray100)
        .modifier(SSTypoModifier(.title_m))

      SSSelectableItemsView(store: store.scope(state: \.selection, action: \.scope.selection))

      Spacer()
    }.padding(.horizontal, 16)
  }

  @ViewBuilder
  private func nextButton() -> some View {
    Button {
      store.sendViewAction(.tappedNextButton)
    } label: {
      Text("다음")
        .foregroundStyle(SSColor.gray10)
    }
    .allowsHitTesting(store.isPushable)
    .frame(maxWidth: .infinity, maxHeight: 60)
    .background(store.isPushable ? SSColor.gray100 : SSColor.gray30)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }
    }
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
