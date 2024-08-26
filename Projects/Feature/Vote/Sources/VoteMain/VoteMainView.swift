//
//  VoteMainView.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import SSAlert
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
            makeVoteList()
          } header: {
            makeHeaderSection()
          }
        }
      }
    }
    .refreshable { @MainActor in
      await store.send(.view(.executeRefresh)).finish()
    }
  }

  @ViewBuilder
  private func makeVoteList() -> some View {
    if !store.voteMainProperty.votePreviews.isEmpty {
      LazyVStack(alignment: .leading, spacing: 12) {
        ForEach(store.voteMainProperty.votePreviews) { item in
          makeVotePreview(item: item)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(SSColor.gray10)
    }
  }

  @ViewBuilder
  private func makeVotePreview(item: VotePreviewProperty) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(spacing: 8) {
        // Top Section
        VStack(spacing: 4) {
          HStack {
            HStack(alignment: .center, spacing: 0) {
              // SectionTitleText
              Text(item.categoryTitle)
                .modifier(SSTypoModifier(.title_xxxs))
                .foregroundStyle(SSColor.orange60)

              SSImage
                .voteMainRightArrow
            }

            Spacer()

            Text(item.createdAtLabel)
              .modifier(SSTypoModifier(.text_xxxs))
              .foregroundStyle(SSColor.gray60)
          }
          // Content
          Text(item.content)
            .modifier(SSTypoModifier(.text_xxxs))
            .foregroundStyle(SSColor.gray100)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)

        // Middle Section

        VStack(spacing: 4) {
          let buttonTitles = item.voteItemsTitle
          ForEach(0 ..< buttonTitles.count, id: \.self) { index in
            if let currentTitle = buttonTitles[safe: index] {
              SSButton(
                .init(
                  size: .xsh36,
                  status: .active,
                  style: .ghost,
                  color: .black,
                  buttonText: currentTitle,
                  frame: .init(maxWidth: .infinity, alignment: .leading)
                )
              ) {}
                .disabled(true)
            }
          }
        }
        .frame(maxWidth: .infinity)

        // Bottom Section
        HStack(spacing: 0) {
          Text(item.participateCountLabel) // Participants Count
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.blue60)

          Spacer()

          Button {
            store.send(.view(.tappedReportButton(item.id)))
          } label: {
            SSImage
              .voteWarning
          }
        }
        .frame(maxWidth: .infinity)
      }
    }
    .padding(16)
    .background(SSColor.gray15)
    .cornerRadius(8)
    .contentShape(Rectangle())
    .onTapGesture {
      store.send(.view(.tappedVoteItem(id: item.id)))
    }
    .onAppear {
      store.sendViewAction(.voteItemOnAppear(item))
    }
  }

  @ViewBuilder
  private func makeBottomVoteListFilter() -> some View {
    HStack(alignment: .center, spacing: 0) {
      let isPopular = store.voteMainProperty.sortByPopular
      // 투표 많은 순
      HStack(alignment: .center, spacing: 8) {
        Circle()
          .frame(width: Metrics.circleWithAndHeight, height: Metrics.circleWithAndHeight)

        Text(Constants.mostVotesFilterText)
          .modifier(SSTypoModifier(.title_xxxs))
      }
      .foregroundStyle(isPopular ? SSColor.orange60 : SSColor.gray40)
      .contentShape(Rectangle())
      .onTapGesture {
        store.sendViewAction(.tappedPopularSortButton)
      }

      Spacer()

      // 내 글 보기
      let isOnlyMyPostFilter = store.voteMainProperty.onlyMineVoteFilter
      HStack(spacing: 4) {
        if isOnlyMyPostFilter {
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
      .foregroundStyle(isOnlyMyPostFilter ? SSColor.orange60 : SSColor.gray40)
      .contentShape(Rectangle())
      .onTapGesture {
        store.sendViewAction(.tappedOnlyMyPostButton)
      }
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    .background(SSColor.gray10)
  }

  /// Sticky Header
  @ViewBuilder
  private func makeHeaderSection() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(store.voteMainProperty.voteSectionItems) { item in
        let isSelected = store.voteMainProperty.selectedVoteSectionItem == item
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
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.viewAligned)
      .scrollIndicators(.hidden)
    }
    .padding(.all, 16)
    .background(SSColor.gray10)
  }

  @ViewBuilder
  private func makeFavoriteSectionItem(_ item: PopularVoteItem) -> some View {
    VStack(spacing: 12) {
      // Top Content
      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 0) {
          Text(item.categoryTitle)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.gray60)

          SSImage
            .voteRightArrow
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Text(item.content)
          .modifier(SSTypoModifier(.text_xxxs))
          .foregroundStyle(SSColor.gray100)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      // Button Content
      HStack(alignment: .center, spacing: 8) {
        SSImage
          .voteSystemLogo

        Text("\(item.participantCount)명 참여 중")
          .modifier(SSTypoModifier(.title_xxxs))
          .multilineTextAlignment(.center)
          .foregroundColor(SSColor.gray100)
          .frame(maxWidth: .infinity, alignment: .top)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(SSColor.gray10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    .padding(16)
    .frame(width: Metrics.favoriteItemWidth)
    .background(SSColor.gray15)
    .cornerRadius(8)
    .contentShape(Rectangle())
    .onTapGesture {
      store.sendViewAction(.tappedVoteItem(id: item.id))
    }
  }

  @ViewBuilder
  private func makeFloatingButton() -> some View {
    Button {
      store.send(.view(.tappedFloatingButton))
    } label: {
      ZStack {
        Circle()
          .foregroundStyle(SSColor.gray100)
          .frame(width: 48, height: 48)
          .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 8)

        SSImage
          .voteWrite
      }
      .padding(.all, 20)
    }
  }

  @ViewBuilder
  private func makeVoteNavigationStackView(@ViewBuilder rootView: () -> some View) -> some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.scope.votePath.path)) {
      rootView()
    } destination: { store in
      switch store.case {
      case let .write(store):
        WriteVoteView(store: store)

      case let .search(store):
        VoteSearchView(store: store)

      case let .edit(store):
        EditMyVoteView(store: store)
      case let .detail(store):
        VoteDetailView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeVoteRootView() -> some View {
    ZStack {
      SSColor
        .gray20
        .ignoresSafeArea()

      ZStack(alignment: .bottomTrailing) {
        VStack(spacing: 0) {
          HeaderView(store: store.scope(state: \.header, action: \.scope.header))
            .background(SSColor.gray10)
          makeContentView()
            .ssLoading(store.isLoading)
        }
      }
    }
    .overlay(alignment: .bottomTrailing) {
      makeFloatingButton()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .sSAlert(
      isPresented: $store.isPresentReport.sending(\.view.presentReport),
      messageAlertProperty: .init(
        titleText: Constants.reportAlertTitle,
        contentText: Constants.reportAlertDescription,
        checkBoxMessage: .text(Constants.checkBoxMessage),
        buttonMessage: .doubleButton(
          left: Constants.reportAlertCancelText,
          right: Constants.reportAlertConfirmText
        ),
        didTapCompletionButton: { isCheck in
          store.send(.view(.tappedReportConfirmButton(isCheck: isCheck)))
        }
      )
    )
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
  }

  var body: some View {
    makeVoteNavigationStackView {
      makeVoteRootView()
    }
  }

  private enum Metrics {
    static let favoriteItemWidth: CGFloat = 296
    static let circleWithAndHeight: CGFloat = 6
  }

  private enum Constants {
    static let favoriteVoteTitleText: String = "가장 인기 있는 투표"
    static let mostVotesFilterText = "투표 많은순"
    static let myBoardOnlyFilterText = "내 글 보기"

    static let reportAlertTitle = "해당 글을 신고할까요?"
    static let reportAlertDescription = """
    신고된 글은 수수의 확인 후 제재됩니다.\n이 작성자의 글을 더 이상 보고 싶지 않다면\n작성자를 바로 차단해 주세요.
    """
    static let reportAlertCancelText = "취소"
    static let reportAlertConfirmText = "신고하기"
    static let checkBoxMessage = "작성자도 바로 차단하기"
  }
}
