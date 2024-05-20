//
//  WriteVoteView.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct WriteVoteView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<WriteVote>

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
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
  }

  @ViewBuilder
  private func makeWritableVoteContent() -> some View {
    VStack(alignment: .leading, spacing: 24) {
      // VoteTextContent
      TextField(
        "VoteTextContent",
        text: $store.helper.voteTextContent.sending(\.view.editedVoteTextContent),
        prompt: Text(store.helper.voteTextContentPrompt).foregroundStyle(SSColor.gray40),
        axis: .vertical
      )
      .modifier(SSTypoModifier(.text_xxs))
      .foregroundStyle(SSColor.gray100)

      // SelectableItems
    }
    .padding(0)
  }

  @ViewBuilder
//  private func makeSelectableItems(_: WriteVoteSelectableItem) -> some View {
  ////    TextFieldButtonWithTCAView(
  ////      size: .mh44,
  ////      prompt: "dd",
  ////      store: Store<TextFieldButtonWithTCA<TextFieldButtonWithTCAPropertiable>.State, TextFieldButtonWithTCA<TextFieldButtonWithTCAPropertiable>.Action>())
//  }

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
