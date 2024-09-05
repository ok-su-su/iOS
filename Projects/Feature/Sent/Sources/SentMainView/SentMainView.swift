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
import SSCreateEnvelope
import SSFirebase
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
    makeUserEnvelopes()
  }

  @ViewBuilder
  private func makeEmptyEnvelopesView() -> some View {
    LazyVStack(alignment: .center, spacing: 16) {
      Text(Constants.emptyEnvelopesText)
        .modifier(SSTypoModifier(.text_s))
        .foregroundStyle(SSColor.gray50)
      SSButton(Constants.emptyEnvelopeButtonProperty) {
        store.sendViewAction(.tappedEmptyEnvelopeButton)
      }
    }
  }

  @ViewBuilder
  private func makeUserEnvelopes() -> some View {
    LazyVStack(spacing: 8) {
      ForEach(
        store.scope(state: \.envelopes, action: \.scope.envelopes)
      ) { store in
        EnvelopeView(store: store)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  @ViewBuilder
  func makeFilterSection() -> some View {
    // MARK: - 필터 버튼

    ScrollView(.horizontal) {
      HStack(alignment: .center, spacing: Constants.topButtonsSpacing) {
        makeSortButton()
        makeFilterButtonView()
        makeAmountRangeButtonView()
        makeFilteredPeopleView()
      }
    }
    .padding(.bottom, 16)
    .background(SSColor.gray15)
    .scrollIndicators(.hidden)
  }

  @ViewBuilder
  private func makeFilterButtonView() -> some View {
    // 정렬된 사람이 없을 때
    if !store.state.isFilteredHeaderButtonItem {
      SSButton(Constants.notSelectedFilterButtonProperty) {
        store.send(.view(.tappedFilterButton))
      }
    } else {
      // 정렬된 사람이 있을 때
      Button {
        store.send(.view(.tappedFilterButton))
      } label: {
        SSImage.commonFilterWhite
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .frame(height: 32, alignment: .center)
          .background(SSColor.gray100)
          .cornerRadius(4)
      }
    }
  }

  // MARK: - 정렬 버튼

  @ViewBuilder
  private func makeSortButton() -> some View {
    SSButton(.init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: store.sentMainProperty.selectedFilterDial?.description ?? ""
    )) {
      store.sendViewAction(.tappedSortButton)
    }
  }

  @ViewBuilder // amount Range Button
  private func makeAmountRangeButtonView() -> some View {
    if let amountRangeBadgeText = store.sentMainProperty.sentPeopleFilterHelper.amountFilterBadgeText {
      SSButton(
        .init(
          size: .sh32,
          status: .active,
          style: .filled,
          color: .black,
          rightIcon: .icon(SSImage.commonDeleteWhite),
          buttonText: amountRangeBadgeText
        )
      ) {
        store.sendViewAction(.tappedFilteredAmountButton)
      }
    }
  }

  @ViewBuilder
  private func makeFilteredPeopleView() -> some View {
    // 사람 버튼에 대한 표시
    let filtered = store.sentMainProperty.sentPeopleFilterHelper.selectedPerson
    ForEach(0 ..< filtered.count, id: \.self) { index in
      if index < filtered.count {
        let person = filtered[index]
        SSButton(
          .init(
            size: .sh32,
            status: .active,
            style: .filled,
            color: .black,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: person.name
          )
        ) {
          store.sendViewAction(.tappedFilteredPersonButton(id: person.id))
        }
      }
    }
  }

  @ViewBuilder
  private func makeFilterAndEnvelopesContentView() -> some View {
    ZStack {
      ScrollViewWithFilterItems {
        makeFilterSection()
      } content: {
        makeEnvelope()
          .ssLoading(store.isLoading)
      } refreshAction: { @MainActor in
        store.send(.view(.pullRefreshButton))
        await store.mutexManager.waitForFinish()
      }
      .padding(.horizontal, 16)

      if store.envelopes.isEmpty && !store.isLoading {
        makeEmptyEnvelopesView()
      }
    }
  }

  // MARK: - View Body

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray15
        .ignoresSafeArea()

      // Content
      VStack(spacing: 16) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeFilterAndEnvelopesContentView()
      }
    }
    .ssFloatingButton {
      store.sendViewAction(.tappedFloatingButton)
    }
    .navigationBarBackButtonHidden()
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .modifier(DestinationsModifier(store: store))
    .ssAnalyticsScreen(moduleName: .Sent(.main))
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let topButtonsSpacing: CGFloat = 8
    static let emptyEnvelopesText: String = "아직 보낸 봉투가 없습니다."
    static let addNewEnvelopeButtonText: String = "보낸 봉투 추가하기"

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

// MARK: - DestinationsModifier

private struct DestinationsModifier: ViewModifier {
  @Bindable var store: StoreOf<SentMain> // StoreType은 실제 store의 타입으로 교체해야 합니다

  func body(content: Content) -> some View {
    content
      .fullScreenCover(isPresented: $store.presentCreateEnvelope.sending(\.view.presentCreateEnvelope)) {
        CreateEnvelopeRouterBuilder(
          currentType: .sent,
          initialCreateEnvelopeRequestBody: store.createEnvelopeProperty
        ) { data in
          store.sendViewAction(.finishedCreateEnvelopes(data))
        }
      }
      .fullScreenCover(item: $store.scope(state: \.presentDestination?.filter, action: \.scope.presentDestination.filter)) { store in
        SentEnvelopeFilterView(store: store)
      }
      .fullScreenCover(item: $store.scope(state: \.presentDestination?.searchEnvelope, action: \.scope.presentDestination.searchEnvelope)) { store in
        SentSearchView(store: store)
      }
      .fullScreenCover(
        item: $store.scope(
          state: \.presentDestination?.specificEnvelope,
          action: \.scope.presentDestination.specificEnvelope
        )
      ) { store in
        SpecificEnvelopeHistoryRouterView(store: store)
      }
      .selectableBottomSheet(
        store: $store.scope(
          state: \.presentDestination?.filterBottomSheet,
          action: \.scope.presentDestination.filterBottomSheet
        ),
        cellCount: 4
      )
  }
}
