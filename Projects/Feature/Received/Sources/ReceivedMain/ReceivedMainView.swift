//
//  ReceivedMainView.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SSSearch
import SwiftUI

// MARK: - ReceivedMainView

struct ReceivedMainView: View {
  @Bindable var store: StoreOf<ReceivedMain>

  init(store: StoreOf<ReceivedMain>) {
    self.store = store
  }

  @ViewBuilder
  func makeDotLineButton() -> some View {
    Rectangle()
      .strokeBorder(style: StrokeStyle(lineWidth: 1, lineCap: .butt, dash: [4]))
      .foregroundColor(SSColor.gray40)
      .overlay(
        SSImage.commonAdd
          .renderingMode(.template)
          .foregroundColor(SSColor.gray40)
          .frame(width: 18, height: 18)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .contentShape(.rect)
      .cornerRadius(4)
      .onTapGesture {
        store.sendViewAction(.tappedAddLedgerButton)
      }
  }

  @ViewBuilder
  private func makeEmptyLedgersView() -> some View {
    Text(Constants.emptyInventoryText)
      .modifier(SSTypoModifier(.text_s))
      .foregroundColor(SSColor.gray50)
      .frame(maxWidth: .infinity, maxHeight: 30, alignment: .center)
  }

  @ViewBuilder
  private func makeLedgersView() -> some View {
    let gridColumns = [
      // 이유는 모르겠지만 8로 spaicng 설정하면 원하는대로 안나타남.
      GridItem(.flexible(minimum: 116, maximum: .infinity), spacing: 6),
      GridItem(.flexible(minimum: 116, maximum: .infinity), spacing: 6),
    ]
    LazyVGrid(
      columns: gridColumns,
      alignment: .center,
      spacing: 8
    ) {
      ForEach(store.ledgersProperty) { property in
        LedgerBoxView(property)
          .frame(height: ledgerBoxWidthAndHeight)
          .onAppear {
            store.sendViewAction(.onAppearedLedger(property))
          }
          .onTapGesture {
            store.sendViewAction(.tappedLedgerBox(property))
          }
      }
      // add Ledger View
      makeDotLineButton()
        .frame(height: ledgerBoxWidthAndHeight)
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  func makeFilterSection() -> some View {
    // MARK: - 필터 버튼

    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        SSButton(.init(
          size: .sh32,
          status: .active,
          style: .ghost,
          color: .black,
          leftIcon: .icon(SSImage.commonOrder),
          buttonText: store.sortProperty.selectedFilterDial?.description ?? ""
        )) {
          store.sendViewAction(.tappedSortButton)
        }

        // MARK: - 정렬 버튼

        // 정렬된 사람이 없을 때
        if !store.isFilteredItem {
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

          // amount Range Button
          if let amountRangeBadgeText = store.filterProperty.selectedFilterDateTextString {
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
              store.sendViewAction(.tappedFilteredDateButton)
            }
          }

          // 사람 버튼에 대한 표시
          let filtered = store.filterProperty.selectedLedgers
          ForEach(filtered) { property in
            SSButton(
              .init(
                size: .sh32,
                status: .active,
                style: .filled,
                color: .black,
                rightIcon: .icon(SSImage.commonDeleteWhite),
                buttonText: property.title
              )
            ) {
              store.sendViewAction(.tappedFilteredPersonButton(id: property.id))
            }
          }
        }
      }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.bottom, 16)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeFilterAndLedgersView() -> some View {
    ZStack {
      if !store.isLoading && store.ledgersProperty.isEmpty {
        makeEmptyLedgersView()
      }

      ScrollViewWithFilterItems {
        makeFilterSection()
          .ssLoading(store.isLoading)
      } content: {
        makeLedgersView()
      } refreshAction: {
        store.sendViewAction(.pullRefreshButton)
      }
    }
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray15
        .ignoresSafeArea()

      VStack(spacing: 16) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeFilterAndLedgersView()
      }
    }
    .ssFloatingButton {
      store.sendViewAction(.tappedFloatingButton)
    }
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
    .onAppear {
      store.sendViewAction(.onAppear(true))
    }
    .fullScreenCover(item: $store.scope(state: \.presentDestination?.search, action: \.scope.presentDestination.search)) { store in
      ReceivedSearchView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.presentDestination?.detail, action: \.scope.presentDestination.detail)) { store in
      LedgerDetailRouterView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.presentDestination?.createLedger, action: \.scope.presentDestination.createLedger)) { store in
      CreateLedgerRouterView(store: store)
    }
    .selectableBottomSheet(store: $store.scope(state: \.presentDestination?.sort, action: \.scope.presentDestination.sort), cellCount: 4)
    .fullScreenCover(item: $store.scope(state: \.presentDestination?.filter, action: \.scope.presentDestination.filter)) { store in
      ReceivedFilterView(store: store)
    }
    .navigationBarBackButtonHidden()
  }

  /// Box Size +  horizontal Spacing
  var ledgerBoxWidthAndHeight: CGFloat = (UIScreen.main.bounds.width - (16 * 2) - 8) / 2

  private enum Constants {
    // MARK: Property

    static let commonSpacing: CGFloat = 16
    static let filterSpacing: CGFloat = 8
    static let emptyInventoryText: String = "아직 받은 장부가 없어요"

    static let notSelectedFilterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )
  }
}
