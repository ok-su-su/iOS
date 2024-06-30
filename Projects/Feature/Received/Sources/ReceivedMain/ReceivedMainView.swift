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
        store.sendViewAction(.didTapInventoryView)
      }
  }

  @ViewBuilder
  func makeEmptyView() -> some View {
    GeometryReader { geometry in
      if store.ledgersProperty.isEmpty {
        VStack {
          makeDotLineButton()
            .padding(.horizontal, InventoryFilterConstants.commonSpacing)
        }.frame(width: geometry.size.width, height: 160, alignment: .topLeading)

        VStack {
          Spacer()
          Text(InventoryFilterConstants.emptyInventoryText)
            .modifier(SSTypoModifier(.text_s))
            .foregroundColor(SSColor.gray50)
            .frame(width: geometry.size.width, height: 30, alignment: .center)
          Spacer()
        }
      } else {
        ScrollView {
          LazyVGrid(columns: inventoryColumns) {
            // TODO: LedgerBox View 연결
//            ForEach(store.scope(state: \.inventorys, action: \.reloadInvetoryItems)) { boxStore in
//              LedgerBoxView(store: boxStore)
//                .padding(.trailing, InventoryFilterConstants.commonSpacing)
//                .onTapGesture {
//                  store.send(.didTapInventoryView)
//                }
//            }
            VStack {
              makeDotLineButton()
                .padding([.leading, .trailing], InventoryFilterConstants.commonSpacing)
            }
          }
        }
      }
    }
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
      .padding(.horizontal, InventoryFilterConstants.commonSpacing)
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

  private enum InventoryFilterConstants {
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
  }
}
