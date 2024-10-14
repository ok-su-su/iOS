//
//  LedgerDetailFilterView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SSFilter
import SSLayout
import SwiftUI

struct LedgerDetailFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LedgerDetailFilter>

  // MARK: Init

  init(store: StoreOf<LedgerDetailFilter>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        SSFilterView(
          store: store.scope(
            state: \.filterState,
            action: \.scope.filterAction
          ),
          topSectionTitle: "보낸 사람",
          textFieldPrompt: "보낸 사람을 검색해 보세요"
        )
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let prompt: Text = .init("보낸 사람을 검색해보세요")
    static let progressTitleText: String = "받은 봉투 금액"
    static let topSectionTitle: String = "보낸 사람"
  }
}
