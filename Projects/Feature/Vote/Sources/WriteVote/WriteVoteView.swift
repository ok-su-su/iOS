//
//  WriteVoteView.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
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
      makeWritableVoteContent()
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
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
  }

  @ViewBuilder
  private func makeWritableVoteContent() -> some View {
    VStack(alignment: .center, spacing: 24) {
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
      VStack(spacing: 8) {
        ForEach(store.scope(state: \.selectableItems, action: \.scope.selectableItems)) { scopedStore in
          TextFieldButtonWithTCAView(
            size: .mh52,
            prompt: store.helper.voteTextContentPrompt,
            store: scopedStore
          )
        }
      }

      // Add Button
      Button {
        store.send(.view(.tappedAddSectionItemButton))
        let cc = store.selectableItems.count
        os_log("cc = \(cc)")
        let ccc = store.helper.selectableItem.count
        os_log("ccc = \(ccc)")
      } label: {
        SSImage
          .commonAdd
          .resizable()
          .frame(width: 24, height: 24)
          .padding(4)
          .background(SSColor.orange60)
          .clipShape(Circle())
      }
    }
    .padding(0)
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
