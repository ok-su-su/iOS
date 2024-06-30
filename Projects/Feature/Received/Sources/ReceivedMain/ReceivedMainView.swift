//
//  ReceivedMainView.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSSearch
import SwiftUI

// MARK: - ReceivedMainView

struct ReceivedMainView: View {
  @Bindable var store: StoreOf<ReceivedMain>
  private let inventoryColumns = [GridItem(.flexible()), GridItem(.flexible())]

  init(store: StoreOf<ReceivedMain>) {
    self.store = store
  }

  @ViewBuilder
  func makeDotLineButton() -> some View {
    Rectangle()
      .strokeBorder(style: StrokeStyle(lineWidth: 1, lineCap: .butt, dash: [4]))
      .foregroundColor(SSColor.gray40)
      .frame(width: 160, height: 160)
      .overlay(
        SSImage.commonAdd
          .renderingMode(.template)
          .foregroundColor(SSColor.gray40)
          .frame(width: 18, height: 18)
      )
      .fixedSize()
      .onTapGesture {
        store.sendViewAction(.tappedAddLedgerButton)
      }
  }

  @ViewBuilder
  func makeEmptyView() -> some View {
    GeometryReader { geometry in
      if store.ledgersProperty.isEmpty {
        VStack {
          makeDotLineButton()
            .padding(.horizontal, Constants.commonSpacing)
        }.frame(width: geometry.size.width, height: 160, alignment: .topLeading)

        VStack {
          Spacer()
          Text(Constants.emptyInventoryText)
            .modifier(SSTypoModifier(.text_s))
            .foregroundColor(SSColor.gray50)
            .frame(width: geometry.size.width, height: 30, alignment: .center)
          Spacer()
        }
      } else {
        ScrollView {
          LazyVGrid(
            columns: inventoryColumns,
            alignment: .center,
            spacing: 8
          ) {
            // TODO: LedgerBox View 연결
            ForEach(store.ledgersProperty) { property in
              LedgerBoxView(property)
                .frame(height: ledgerBoxWithAndHeight)
            }
            VStack {
              // add Ledger View
              makeDotLineButton()
                .padding([.leading, .trailing], Constants.commonSpacing)
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

          // amount Range Button
          if let amountRangeBadgeText = store.filterProperty.filteredDateTextString {
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

          // 사람 버튼에 대한 표시
          let filtered = store.filterProperty.selectedLedger
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
                  buttonText: person.categoryName
                )
              ) {
                store.sendViewAction(.tappedFilteredPersonButton(id: person.id))
              }
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.bottom, 16)
  }


  @ViewBuilder
  func makeFilterView() -> some View {
    GeometryReader { geometry in
      VStack {
//      HStack(spacing: InventoryFilterConstants.filterSpacing) {
//        SSButton(.init(
//          size: .sh32,
//          status: .active,
//          style: .ghost,
//          color: .black,
//          buttonText: store.selectedSortItem.rawValue
//        )) {
//          store.send(.didTapLatestButton)
//        }
//
//        ZStack {
//          NavigationLink(state: InventoryRouter.Path.State.inventoryFilterItem(
//            .init(
//              startDate: Shared(.now),
//              endDate: Shared(.now),
//              selectedFilter: Shared([]),
//              ssButtonProperties: Shared([:])
//            )
//          )
//          ) {
//            SSButton(InventoryFilterConstants.filterButtonProperty) {
//              inventoryStore.send(.didTapFilterButton)
//            }
//            .allowsHitTesting(false)
//          }
//        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(width: geometry.size.width, height: 32, alignment: .topLeading)
      .padding(.horizontal, Constants.commonSpacing)
    }
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

        makeFilterView()
          .frame(height: 32)
        makeEmptyView()
      }
//      InventoryFloatingButton(floatingStore: store.scope(state: \.floatingState, action: \.setFloatingView))
//        .padding(.trailing, 20)
//        .padding(.bottom, 20)

    }.safeAreaInset(edge: .bottom) {
      SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
        .background {
          Color.white
        }
        .ignoresSafeArea()
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
    }
    .fullScreenCover(item: $store.scope(state: \.search, action: \.scope.search)) { store in
      ReceivedSearchView(store: store)
    }
    .navigationBarBackButtonHidden()
//    .sheet(item: $store.scope(state: \.sortSheet, action: \.scope.sortSheet)) { store in
//      InventorySortSheetView(store: store)
//        .presentationDetents([.height(240), .medium, .large])
//        .presentationDragIndicator(.automatic)
//    }
//    .fullScreenCover(item: $store.scope(state: \.searchInvenotry, action: \.showSearchView)) { store in
//      InventorySearchView(store: store)
//    }
  }

  /// Box Size +  horizontal Spacing
  var ledgerBoxWithAndHeight: CGFloat = (UIScreen.main.bounds.width - 16 * 2 + 8) / 2

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
