//
//  SearchEnvelopeView.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SearchEnvelopeView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SearchEnvelope>

  // MARK: Content

  @ViewBuilder
  private func makeMiddleContent() -> some View {
    if store.isEmptySearchHistory {
      makeNoSearchHistory()
    } else {
      makeSearchHistory()
    }
  }

  @ViewBuilder
  private func makeNoSearchHistory() -> some View {
    VStack(alignment: .center, spacing: 4) {
      Text(Constants.emptySearchViewTitle)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray80)
      Text(Constants.emptySearchViewDescription)
        .modifier(SSTypoModifier(.text_xxs))
        .foregroundStyle(SSColor.gray80)
        .multilineTextAlignment(.center)
    }
  }

  @ViewBuilder
  private func makeSearchHistory() -> some View {
    VStack(spacing: 16) {
      Text(Constants.latestSearchTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .frame(maxWidth: .infinity, alignment: .leading)

      ForEach(0 ..< max(store.latestSearchCount, 5), id: \.self) { ind in
        if store.latestSearch.indices.contains(ind) {
          HStack(spacing: 0) {
            Text(store.latestSearch[ind])
              .modifier(SSTypoModifier(.title_s))
              .foregroundStyle(SSColor.gray100)
              .frame(maxWidth: .infinity, alignment: .leading)
              .onTapGesture {
                store.send(.tappedLatestSearchName(store.latestSearch[ind]))
              }
            SSImage
              .commonDeleteGray
              .onTapGesture {
                store.send(.tappedLatestSearchNameDelete(store.latestSearch[ind]))
              }
          }
        }
      }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      CustomTextFieldView(store: store.scope(state: \.customTextField, action: \.customTextField))
      Spacer()
        .frame(height: 32)
      makeMiddleContent()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.header))
        makeContentView()
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 16)
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let emptySearchViewTitle: String = "어떤 봉투를 찾아드릴까요?"
    static let emptySearchViewDescription: String = "사람 이름, 보낸 금액, 경조사 명 등을\n검색해볼 수 있어요"

    static let latestSearchTitle: String = "최근 검색"
  }
}
