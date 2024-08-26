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
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        makeHeaderSection()
        makeWritableVoteContent()
      }
    }
    .contentShape(Rectangle())
    .whenTapDismissKeyboard()
    .scrollBounceBehavior(.basedOnSize)
  }

  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(store.helper.headerSectionItems) { item in
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
        prompt: Text(store.helper.voteTextContentPrompt).foregroundStyle(SSColor.gray40).applySSFontToText(.text_xxs),
        axis: .vertical
      )
      .font(.custom(.text_xxs))
      .foregroundStyle(SSColor.gray100)
      .padding(.horizontal, 16)

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
      .padding(.horizontal, 16)

      // Add Button
      Button {
        store.send(.view(.tappedAddSectionItemButton))
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

  @ViewBuilder
  private func makeCreateButton() -> some View {
    Button {
      store.sendViewAction(.tappedCreateButton)
    } label: {
      Text("등록")
        .applySSFont(.title_xxs)
        .foregroundStyle(store.isCreatable ? SSColor.gray100 : SSColor.gray40)
        .padding(.horizontal, 16)
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .overlay(alignment: .trailing) {
            makeCreateButton()
          }

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
