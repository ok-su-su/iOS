//
//  LedgerDetailMainView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - LedgerDetailMainView

struct LedgerDetailMainView: View {
  @Bindable var store: StoreOf<LedgerDetailMain>

  @ViewBuilder
  private func makeTopContentView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(store.accountProperty.priceText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundColor(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)

      Rectangle()
        .fill(SSColor.gray30)
        .frame(width: 61, height: 24)
        .cornerRadius(4)
        .overlay {
          Text("총 \(store.accountProperty.accountList.count)개")
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray70)
        }
        .padding(.horizontal, 16)

      VStack {
        HStack {
          Text("경조사 카테고리")
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

          Text(store.accountProperty.category.type)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray80)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 16)
        }

        Spacer()
          .frame(height: 4)

        HStack {
          Text("경조사 명")
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

          Text(store.accountProperty.accountTitleText)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray80)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 16)
        }

        Spacer()
          .frame(height: 4)

        HStack {
          Text("경조사 기간")
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

          Text(store.accountProperty.dateText)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundColor(SSColor.gray80)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
      }

    }.frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeLineView() -> some View {
    Rectangle()
      .fill(SSColor.gray25)
      .frame(maxWidth: .infinity, maxHeight: 8)
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    HStack(spacing: 8) {
//      ZStack {
//        NavigationLink(state: InventoryAccountDetailRouter.Path.State.showInventoryAccountFilter(.init(accountFilterHelper: Shared(.init(remittPerson: []))))) {
//          SSButton(InventoryAccountDetailConstants.filterButtonProperty) {
//            store.send(.didTapFilterButton)
//          }.allowsHitTesting(false)
//        }
//      }

      SSButton(InventoryAccountDetailConstants.sortButtonProperty) {}
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView {
      ForEach(store.scope(state: \.accountItems, action: \.reloadAccountItems)) { store in
        InventoryAccountView(store: store)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray15
        .ignoresSafeArea()
      ZStack(alignment: .bottomTrailing) {
        VStack(spacing: 0) {
          HeaderView(store: store.scope(state: \.headerType, action: \.setHeaderView))
            .padding(0)

          makeTopContentView()
            .background {
              Color.white
            }
            .padding(0)

          makeLineView()
            .padding(0)

          Spacer()
            .frame(height: 16)

          makeFilterContentView()

          Spacer()
            .frame(height: 16)

          makeContentView()
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      SSTabbar(store: store.scope(state: \.tabbarType, action: \.setTabbarView))
        .background {
          Color.white
        }
        .ignoresSafeArea()
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
    }
    .navigationBarBackButtonHidden()
  }

  private enum InventoryAccountDetailConstants {
    static let filterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )

    static let sortButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "정렬"
    )
  }
}
