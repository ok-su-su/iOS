//
//  EditMyVoteView.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct EditMyVoteView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<EditMyVote>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeHeaderSection()
    }
  }

  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(store.helper.availableSection) { item in
        SSButton(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .black,
            buttonText: item.title
          )) {}
          .disabled(true)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
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
