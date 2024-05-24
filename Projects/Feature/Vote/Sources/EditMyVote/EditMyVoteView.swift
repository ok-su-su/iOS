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
    VStack(spacing: 24) {
      makeHeaderSection()
      makeVoteContent()
      Spacer()
    }
  }

  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(store.helper.availableSection) { item in
        let isSelected = store.helper.selectedSection == item
        SSButton(
          .init(
            size: .xsh28,
            status: isSelected ? .active : .inactive,
            style: .filled,
            color: .black,
            buttonText: item.title
          )) {
            store.send(.view(.tappedSection(item)))
          }
          .disabled(true)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
  }

  @ViewBuilder
  private func makeVoteContent() -> some View {
    VStack(alignment: .center, spacing: 24) {
      // VoteTextContent
      TextField(
        "VoteTextContent",
        text: $store.helper.textFieldText.sending(\.view.editedVoteTextContent),
        prompt: nil,
        axis: .vertical
      )
      .frame(maxWidth: .infinity, minHeight: 24)
      .modifier(SSTypoModifier(.text_xxs))
      .foregroundStyle(SSColor.gray100)
      .padding(.horizontal, 16)
    }

    // VoteItem
    VStack(spacing: 8) {
      ForEach(0 ..< store.helper.voteItemProperties.count, id: \.self) { ind in
        let title = store.helper.voteItemProperties[ind]
        Text(title)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray100)
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(SSColor.orange10)
          .clipShape(RoundedRectangle(cornerRadius: 4))
      }
    }
    .padding(.horizontal, 16)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
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
