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
import SSToast

struct EditMyVoteView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<EditMyVote>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        makeHeaderSection()
        makeVoteContent()
      }
    }
    .contentShape(Rectangle())
    .whenTapDismissKeyboard()
    .scrollBounceBehavior(.basedOnSize)
  }

  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(store.headerSectionItem) { item in
        let isSelected = store.selectedHeaderSectionItem == item
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
  private func makeVoteContent() -> some View {
    VStack(alignment: .center, spacing: 24) {
      // VoteTextContent
      TextField(
        "VoteTextContent",
        text: $store.textFieldText.sending(\.view.editedVoteTextContent),
        prompt: nil,
        axis: .vertical
      )
      .font(.custom(.text_xxs))
      .modifier(SSTypoModifier(.text_xxs))
      .foregroundStyle(SSColor.gray100)
      .padding(.horizontal, 16)

      // VoteItem
      VStack(spacing: 8) {
        ForEach(store.voteDetailProperty.options) { item in
          Text(item.content)
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
  }

  @ViewBuilder
  private func makeCreateButton() -> some View {
    Button {
      store.sendViewAction(.tappedEditConfirmButton)
    } label: {
      Text("등록")
        .foregroundStyle(SSColor.gray100)
        .applySSFont(.title_xxs)
        .foregroundStyle(store.isEditConfirmable ? SSColor.gray100 : SSColor.gray40)
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
          .ssLoading(store.isLoading)
          .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
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
