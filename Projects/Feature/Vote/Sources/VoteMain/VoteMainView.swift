//
//  VoteMainView.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct VoteMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<VoteMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 8) {
        makeFavoriteSection()
        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
          Section {
            // Bottom Vote Content
            makeBottomVoteListFilter()

          } header: {
            makeHeaderSection()
          }
        }
      }
    }
  }

  @ViewBuilder
  private func makeBottomVoteListFilter() -> some View {
    HStack(alignment: .center, spacing: 0) {
      let selectedFilter = store.voteMainProperty.selectedBottomFilterType
      // 투표 많은 순
      HStack(alignment: .center, spacing: 8) {
        Circle()
          .frame(width: Metrics.circleWithAndHeight, height: Metrics.circleWithAndHeight)

        Text(Constants.mostVotesFilterText)
          .modifier(SSTypoModifier(.title_xxxs))
      }
      .foregroundStyle(selectedFilter == .mostVote ? SSColor.orange60 : SSColor.gray40)
      .onTapGesture {
        store.send(.view(.tappedBottomVoteFilterType(.mostVote)))
      }

      Spacer()

      // 내 글 보기
      HStack(spacing: 4) {
        if selectedFilter == .myBoard {
          SSImage.commonMainCheckBox
            .resizable()
            .frame(width: 20, height: 20)
        } else {
          SSImage
            .commonUnCheckBox
            .resizable()
            .frame(width: 20, height: 20)
        }

        Text(Constants.myBoardOnlyFilterText)
          .modifier(SSTypoModifier(.title_xxxs))
      }
      .foregroundStyle(selectedFilter == .myBoard ? SSColor.orange60 : SSColor.gray40)
      .onTapGesture {
        store.send(.view(.tappedBottomVoteFilterType(.myBoard)))
      }
    }

    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    .background(SSColor.gray10)
  }

  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(SectionHeaderItem.allCases) { item in
        let isSelected = store.voteMainProperty.selectedSectionHeaderItem == item
        SSButton(
          .init(
            size: .xsh28,
            status: isSelected ? .active : .inactive,
            style: .filled,
            color: .black,
            buttonText: item.title
          )) {
            store.send(.view(.tappedSectionItem(item)))
          }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(SSColor.gray10)
  }

  @ViewBuilder
  private func makeTabBar() -> some View {
    SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
      .background {
        Color.white
      }
      .ignoresSafeArea()
      .frame(height: 56)
      .toolbar(.hidden, for: .tabBar)
  }

  @ViewBuilder
  private func makeFavoriteSection() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(Constants.favoriteVoteTitleText)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)

      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(store.voteMainProperty.favoriteVoteItems) { item in
            makeFavoriteSectionItem(item)
          }
        }
      }
      .scrollIndicators(.hidden)
    }
    .padding(.vertical, 16)
    .padding(.leading, 16)
    .background(SSColor.gray10)
  }

  @ViewBuilder
  private func makeFavoriteSectionItem(_ item: FavoriteVoteItem) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      // Top Content
      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 0) {
          Text(item.title)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.gray60)

          SSImage
            .envelopeForwardArrow
        }
        Text(item.content)
          .modifier(SSTypoModifier(.text_xxxs))
          .foregroundStyle(SSColor.gray100)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity)

      HStack(alignment: .center, spacing: 8) {
        SSImage
          .voteSystemLogo

        // Title/xxxs
        Text("\(item.participantCount)명 참여 중")
          .modifier(SSTypoModifier(.title_xxxs))
          .multilineTextAlignment(.center)
          .foregroundColor(SSColor.gray100)
          .frame(maxWidth: .infinity, alignment: .top)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .frame(maxWidth: .infinity, alignment: .center)
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    .padding(16)
    .frame(width: Metrics.favoriteItemWidth, alignment: .topLeading)
    .background(SSColor.gray15)
    .cornerRadius(8)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray20
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
    .safeAreaInset(edge: .bottom) { makeTabBar() }
  }

  private enum Metrics {
    static let favoriteItemWidth: CGFloat = 296
    static let circleWithAndHeight: CGFloat = 6
  }

  private enum Constants {
    static let favoriteVoteTitleText: String = "가장 인기 있는 투표"
    static let mostVotesFilterText = "투표 많은순"
    static let myBoardOnlyFilterText = "내 글 보기"
  }
}
