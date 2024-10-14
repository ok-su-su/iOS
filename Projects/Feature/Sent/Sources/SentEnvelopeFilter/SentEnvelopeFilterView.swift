//
//  SentEnvelopeFilterView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSFilter
import SSFirebase
import SSLayout
import SwiftUI

struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentEnvelopeFilter>

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.header))
          .padding(.bottom, 24)
        SSFilterView(
          store: store.scope(
            state: \.filterState,
            action: \.filterAction
          ),
          topSectionTitle: "보낸사람",
          textFieldPrompt: "보낸사람을검색해보세요"
        )
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
    .ssAnalyticsScreen(moduleName: .Sent(.filter))
  }

  // MARK: Init

  init(store: StoreOf<SentEnvelopeFilter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {
    static let searchTextFieldTitle: String = "보낸 사람"
    static let progressTitleText: String = "전체 금액"
  }
}
