//
//  SentMainView.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

// MARK: - SentMainView

struct SentMainView: View {
  @Bindable
  var store: Store<SentMain.State, SentMain.Action>

  init(store: StoreOf<SentMain>) {
    self.store = store
  }

  @ViewBuilder
  private func makeEnvelope() -> some View {
    if store.state.envelopes.isEmpty {
      VStack {
        Spacer()
        Text(Constants.emptyEnvelopesText)
          .modifier(SSTypoModifier(.text_s))
          .foregroundStyle(SSColor.gray50)
        SSButton(Constants.emptyEnvelopeButtonProperty) {
          store.sendViewAction(.tappedEmptyEnvelopeButton)
        }
        Spacer()
      }
    } else {
      ScrollView {
        ForEach(
          store.scope(state: \.envelopes, action: \.scope.envelopes)
        ) { store in
          EnvelopeView(store: store)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
  }

  @ViewBuilder
  func makeFilterSection() -> some View {
    // MARK: - 필터 버튼

    HStack(spacing: Constants.topButtonsSpacing) {
      SSButton(.init(
        size: .sh32,
        status: .active,
        style: .ghost,
        color: .black,
        leftIcon: .icon(SSImage.commonFilter),
        buttonText: store.sentMainProperty.selectedFilterDial?.description ?? ""
      )) {
        store.sendViewAction(.tappedSortButton)
      }

      // MARK: - 정렬 버튼

      SSButton(Constants.notSelectedFilterButtonProperty) {
        store.send(.view(.tappedFilterButton))
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.bottom, Constants.topButtonsSpacing)
  }

  @ViewBuilder
  func makeTabBar() -> some View {
    SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
      .background {
        Color.white
      }
      .ignoresSafeArea()
      .frame(height: 56)
      .toolbar(.hidden, for: .tabBar)
  }

  // MARK: - View Body

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray15
        .ignoresSafeArea()
      ZStack(alignment: .bottomTrailing) {
        VStack {
          HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          Spacer()
            .frame(height: 16)
          makeFilterSection()
          makeEnvelope()
        }
        FloatingButtonView(store: store.scope(state: \.floatingButton, action: \.scope.floatingButton))
      }.padding(.horizontal, Constants.leadingAndTrailingSpacing)
    }
    .navigationBarBackButtonHidden()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .safeAreaInset(edge: .bottom) { makeTabBar() }
    .fullScreenCover(item: $store.scope(state: \.createEnvelopeRouter, action: \.scope.createEnvelopeRouter)) { store in
      CreateEnvelopeRouterView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.sentEnvelopeFilter, action: \.scope.sentEnvelopeFilter)) { store in
      SentEnvelopeFilterView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.searchEnvelope, action: \.scope.searchEnvelope)) { store in
      SearchEnvelopeView(store: store)
    }
    .modifier(
      SSSelectableBottomSheetModifier(store: $store.scope(state: \.filterBottomSheet, action: \.scope.filterBottomSheet)
      )
    )
    .fullScreenCover(item: $store.scope(state: \.specificEnvelopeHistoryRouter, action: \.scope.specificEnvelopeHistoryRouter)) { store in
      SpecificEnvelopeHistoryRouterView(store: store)
    }
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let topButtonsSpacing: CGFloat = 8
    static let emptyEnvelopesText: String = "아직 보낸 봉투가 없습니다."
    static let addNewEnvelopeButtonText: String = "보낸 봉투 추가하기"

    static let latestButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "최신순"
    )

    static let notSelectedFilterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )

    static let emptyEnvelopeButtonProperty: SSButtonProperty = .init(
      size: .sh40,
      status: .active,
      style: .ghost,
      color: .black,
      buttonText: addNewEnvelopeButtonText
    )
  }
}
