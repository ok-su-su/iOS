//
//  SSSearchView.swift
//  SSSearch
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SSSearchView<item: SSSearchPropertiable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SSSearchReducer<item>>

  public init(store: StoreOf<SSSearchReducer<item>>) {
    self.store = store
  }

  @ViewBuilder
  private func makeSearchTextField() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage
        .commonSearch

      Spacer()
        .frame(width: 8)

      TextField(
        "SearchTextField",
        text: $store.helper.textFieldText.sending(\.changeTextField),
        prompt: Text(store.helper.textFieldPromptText).foregroundStyle(SSColor.gray60)
      )
      .modifier(SSTypoModifier(.text_xxs))
      .frame(maxWidth: .infinity)
      .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(width: 8)

      // commonClose
      if store.helper.textFieldText != "" {
        SSImage
          .commonClose
          .onTapGesture {
            store.send(.tappedCloseButton)
          }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(SSColor.gray15)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeSearchTextField()

      Spacer()
        .frame(height: 32)

      makeSearchContent()
      Spacer()
    }
  }

  @ViewBuilder
  private func makeSearchContent() -> some View {
    if !store.helper.textFieldText.isEmpty {
      makeSearch()
    } else if store.helper.prevSearchedItem.isEmpty {
      makeNoPrevSearchHistory()
    } else {
      makePrevSearchHistory()
    }
  }

  @ViewBuilder
  private func makeSearch() -> some View {
    VStack(spacing: 16) {
      Text(searchResultTitleText)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .frame(maxWidth: .infinity, alignment: .leading)
      let searchResult = store.helper.nowSearchedItem
      if !searchResult.isEmpty {
        // 최대 5개 까지 나타냄
        ForEach(searchResult.prefix(5)) { currentItem in
          HStack(spacing: 16) {
            iconImage(type: store.helper.iconType)

            VStack(spacing: 0) {
              Text("\(currentItem.title)")
                .modifier(SSTypoModifier(.title_s))
                .foregroundStyle(SSColor.gray100)
                .frame(maxWidth: .infinity, alignment: .topLeading)

              HStack(spacing: 8) {
                if let firstDescriptionText = currentItem.firstContentDescription {
                  Text("\(firstDescriptionText)")
                    .modifier(SSTypoModifier(.title_xxs))
                    .foregroundStyle(SSColor.gray40)
                }

                if let secondDescriptionText = currentItem.secondContentDescription {
                  Text("\(secondDescriptionText)")
                    .modifier(SSTypoModifier(.text_xxs))
                    .foregroundStyle(SSColor.gray40)
                }

                Spacer()
              }
            }
          }
          .contentShape(.rect)
          .onTapGesture {
            store.send(.tappedSearchItem(id: currentItem.id))
          }
        }
      } else {
        Spacer()
          .frame(height: 122)
        // 검색 결과가 없을 때
        VStack(alignment: .center, spacing: 4) {
          Text(store.helper.noSearchResultTitle)
            .modifier(SSTypoModifier(.title_xs))
            .foregroundStyle(SSColor.gray80)
          Text(store.helper.noSearchResultDescription)
            .modifier(SSTypoModifier(.text_xxs))
            .foregroundStyle(SSColor.gray80)
            .multilineTextAlignment(.center)
        }
      }
    }
  }

  @ViewBuilder
  private func makeNoPrevSearchHistory() -> some View {
    Spacer()
      .frame(height: 144)
    VStack(alignment: .center, spacing: 4) {
      Text(store.helper.prevSearchedNoContentTitleText)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray80)
      Text(store.helper.prevSearchedNoContentDescriptionText)
        .modifier(SSTypoModifier(.text_xxs))
        .foregroundStyle(SSColor.gray80)
        .multilineTextAlignment(.center)
    }
  }

  @ViewBuilder
  private func makePrevSearchHistory() -> some View {
    VStack(spacing: 16) {
      Text(searchResultTitleText)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .frame(maxWidth: .infinity, alignment: .leading)

      let searchedItem = store.helper.prevSearchedItem
      ForEach(0 ..< min(searchedItem.count, 5), id: \.self) { ind in
        if searchedItem.indices.contains(ind) {
          let currentItem = searchedItem[ind]
          HStack(spacing: 0) {
            Text(currentItem.title)
              .modifier(SSTypoModifier(.title_s))
              .foregroundStyle(SSColor.gray100)
              .frame(maxWidth: .infinity, alignment: .leading)
              .onTapGesture {
                store.send(.tappedPrevItem(id: currentItem.id))
              }
            SSImage
              .commonDeleteGray
              .onTapGesture {
                store.send(.tappedDeletePrevItem(id: currentItem.id))
              }
          }
        }
      }
    }
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
        .whenTapDismissKeyboard()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  @ViewBuilder
  func iconImage(type: SSSearchIconType) -> some View {
    switch type {
    case .sent:
      SSImage.envelopeMainFill
    case .inventory:
      SSImage.inventoryMainFill
    case .vote:
      SSImage.voteMainFill
    }
  }

  // Constnats (cant use static enum because of Generic
  private let searchResultTitleText: String = "검색 결과"
  private let latestSearchTitle: String = "최근 검색"
}
