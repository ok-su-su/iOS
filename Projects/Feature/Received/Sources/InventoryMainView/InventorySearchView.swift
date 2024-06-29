//
//  InventorySearchView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventorySearchView

struct InventorySearchView: View {
  @Bindable var store: StoreOf<InventorySearch>

  @ViewBuilder
  private func makeContentView() -> some View {
    if store.searchText != "" {
      makeSearch()
    } else if store.isEmptySearchHistory {
      Spacer()
        .frame(height: 136)
      makeEmptyView()
    } else {
      makeHistoryView()
    }
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("최근 검색")
        .foregroundStyle(SSColor.gray60)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(maxWidth: .infinity, alignment: .leading)

      ForEach(0 ..< min(store.latestSearchCount, 5), id: \.self) { id in
        let latestSearch = store.searchHelper.latestKeyword
        if latestSearch.indices.contains(id) {
          HStack(spacing: 0) {
            Text(store.searchHelper.latestKeyword[id])
              .modifier(SSTypoModifier(.title_s))
              .foregroundColor(SSColor.gray100)
              .frame(maxWidth: .infinity, alignment: .leading)
              .onTapGesture {
                store.send(.didTapLatestSearch(latestSearch[id]))
              }

            SSImage
              .commonDeleteGray
              .onTapGesture {
                store.send(.didTapKeywordDelete(store.searchHelper.latestKeyword[id]))
              }
          }
        }
      }
    }
  }

  @ViewBuilder
  private func makeEmptyView() -> some View {
    VStack(alignment: .center, spacing: 4) {
      Text("어떤 장부를 찾아드릴까요?")
        .modifier(SSTypoModifier(.title_xs))
      Text("장부 이름, 경조사 카테고리 등을 \n검색해볼 수 있어요")
        .modifier(SSTypoModifier(.text_xxs))
        .foregroundColor(SSColor.gray80)
        .multilineTextAlignment(.center)
    }
  }

  @ViewBuilder
  private func makeSearch() -> some View {
    VStack(spacing: 16) {
      Text("검색 결과")
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundColor(SSColor.gray60)
        .frame(maxWidth: .infinity, alignment: .leading)

      if !store.inventorySearchResult.isEmpty {
        ForEach(0 ..< min(store.inventorySearchResult.count, 5), id: \.self) { id in
          if id < store.inventorySearchResult.count {
            HStack(spacing: 16) {
              SSImage
                .inventoryMainFill

              VStack(spacing: 4) {
                Text("\(store.inventorySearchResult[id].keyword)")
                  .modifier(SSTypoModifier(.title_s))
                  .foregroundColor(SSColor.gray100)
                  .frame(maxWidth: .infinity, alignment: .topLeading)
                HStack(spacing: 8) {
                  Text("\(store.inventorySearchResult[id].type.rawValue)")
                    .modifier(SSTypoModifier(.title_xxs))
                    .foregroundColor(SSColor.gray40)
                    .frame(maxWidth: 37, alignment: .bottomLeading)

                  Text("\(store.inventorySearchResult[id].date)")
                    .modifier(SSTypoModifier(.title_xxs))
                    .foregroundColor(SSColor.gray40)
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                }
              }
            }
          }
        }
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.headerType, action: \.setHeaderView))
        InventorySearchTextFieldView(store: store.scope(state: \.inventoryTextFiled, action: \.setInventoryTextFieldView))
          .padding([.leading, .trailing], 16)

        Spacer()
          .frame(height: 32)
        makeContentView()
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 16)
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
  }
}
