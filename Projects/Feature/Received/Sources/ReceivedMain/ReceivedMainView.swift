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
      .onTapGesture {
        store.sendViewAction(.tappedAddLedgerButton)
      }
  }

  @ViewBuilder
  func makeLedgerView() -> some View {
    GeometryReader { geometry in
      if store.ledgersProperty.isEmpty {
        // 장부가 없을 때 보여줄 뷰
        VStack {
          makeDotLineButton()
        }.frame(width: ledgerBoxHeight, height: ledgerBoxHeight, alignment: .topLeading)
          .padding(.horizontal, 16)

        VStack {
          Spacer()
          Text(Constants.emptyInventoryText)
            .modifier(SSTypoModifier(.text_s))
            .foregroundColor(SSColor.gray50)
            .frame(width: geometry.size.width, height: 30, alignment: .center)
          Spacer()
        }

      } else {
        let gridColumns = [
          GridItem(.adaptive(minimum: ledgerBoxHeight, maximum: .infinity)),
          GridItem(.adaptive(minimum: ledgerBoxHeight, maximum: .infinity)),
        ]
        ScrollView {
          LazyVGrid(
            columns: gridColumns,
            alignment: .center,
            spacing: 8
          ) {
            ForEach(store.ledgersProperty) { property in
              LedgerBoxView(property)
                .frame(height: ledgerBoxHeight)
                .onAppear {
                  store.sendViewAction(.onAppearedLedger(property))
                }
                .onTapGesture {
                  store.sendViewAction(.tappedLedgerBox(property))
                }
            }
            VStack {
              // add Ledger View
              makeDotLineButton()
                .frame(height: ledgerBoxHeight)
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
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
          leftIcon: .icon(SSImage.commonFilter),
          buttonText: store.sortProperty.selectedFilterDial?.description ?? ""
        )) {
          store.sendViewAction(.tappedSortButton)
        }

        // MARK: - 정렬 버튼

        // 정렬된 사람이 없을 때
        if !store.state.isFilteredItem {
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
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.bottom, 16)
    .padding(.horizontal, 16)
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray15
        .ignoresSafeArea()

      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        Spacer()
          .frame(height: 16)

        makeFilterSection()

        makeLedgerView()
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }

      FloatingButtonView {
        store.sendViewAction(.tappedFloatingButton)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)

    }.safeAreaInset(edge: .bottom) {
      SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
        .background {
          Color.white
        }
        .ignoresSafeArea()
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
    }
    .onAppear {
      store.sendViewAction(.onAppear(true))
    }
    .fullScreenCover(item: $store.scope(state: \.search, action: \.scope.search)) { store in
      ReceivedSearchView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.detail, action: \.scope.detail)) { store in
      LedgerDetailRouterView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.createLedger, action: \.scope.createLedger)) { store in
      CreateLedgerRouterView(store: store)
    }
    .modifier(SSSelectableBottomSheetModifier(store: $store.scope(state: \.sort, action: \.scope.sort)))
    .fullScreenCover(item: $store.scope(state: \.filter, action: \.scope.filter)) { store in
      ReceivedFilterView(store: store)
    }
    .navigationBarBackButtonHidden()
  }

  /// Box Size +  horizontal Spacing
  var ledgerBoxHeight: CGFloat = (UIScreen.main.bounds.width - 16 * 2 + 8) / 2

  private enum Constants {
    // MARK: Property

    static let commonSpacing: CGFloat = 16
    static let filterSpacing: CGFloat = 8
    static let emptyInventoryText: String = "아직 받은 장부가 없어요"

    static let latestButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "최신순"
    )

    static let filterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )

    static let inventoryAddButtonProperty: SSButtonProperty = .init(
      size: .sh40,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonAdd),
      buttonText: ""
    )

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
