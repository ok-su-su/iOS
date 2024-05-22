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
        prompt: Text(store.helper.textFieldPromptText)
      )
      .modifier(SSTypoModifier(.text_xxs))
      .frame(maxWidth: .infinity)
      .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(width: 8)

      // commonClose
      if store.helper.textFieldText.isEmpty {
        SSImage
          .commonClose
          .onTapGesture {
            store.send(.tappedCloseButton)
          }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeSearchTextField()

      Spacer()
        .frame(height: 32)

      makeSearchContent()
    }
  }

  @ViewBuilder
  private func makeSearchContent() -> some View {
    if !store.helper.textFieldText.isEmpty {
      makeSearch()
    } else if store.helper.prevSearchedItem.isEmpty {
      makeNoPrevSearchHistory()
    } else {
//      makeSearchHistory()
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
        // 최대 5개 까지
        ForEach(0 ..< min(searchResult.count, 5), id: \.self) { ind in
          if ind < searchResult.count {
            let currentItem = searchResult[ind]
            HStack(spacing: 16) {
              SSImage
                .envelopeMainFill

              VStack(spacing: 0) {
                Text("\(currentItem.title)")
                  .modifier(SSTypoModifier(.title_s))
                  .foregroundStyle(SSColor.gray100)
                  .frame(maxWidth: .infinity, alignment: .topLeading)

                HStack {
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
                }
              }
            }
          }
        }
      } else {
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
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  // Constnats (cant use static enum because of Generic
  private let searchResultTitleText: String = "검색 결과"
  private let latestSearchTitle: String = "최근 검색"
}
