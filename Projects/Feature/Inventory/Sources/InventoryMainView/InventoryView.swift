//
//  InventoryView.swift
//  susu
//
//  Created by Kim dohyun on 4/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import OSLog
import SwiftUI

public struct InventoryView: View {
  @Bindable var inventoryStore: StoreOf<InventoryViewFeature>
  private let inventoryColumns = [GridItem(.flexible()), GridItem(.flexible())]

  public init(inventoryStore: StoreOf<InventoryViewFeature>) {
    self.inventoryStore = inventoryStore
  }

  @ViewBuilder
  public func makeDotLineButton() -> some View {
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
        inventoryStore.send(.didTapAddInventoryButton)
      }
  }

  @ViewBuilder
  public func makeEmptyView() -> some View {
    GeometryReader { geometry in
      if inventoryStore.inventorys.isEmpty {
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
            ForEach(inventoryStore.scope(state: \.inventorys, action: \.reloadInvetoryItems)) { store in
              InventoryBoxView(inventoryBoxstore: store)
                .padding(.trailing, InventoryFilterConstants.commonSpacing)
            }
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
  public func makeFilterView() -> some View {
    GeometryReader { geometry in
      HStack(spacing: InventoryFilterConstants.filterSpacing) {
        SSButton(InventoryFilterConstants.latestButtonProperty) {
          inventoryStore.send(.didTapLatestButton)
        }

        ZStack {
          NavigationLink(state: InventoryRouter.Path.State.inventoryFilterItem(.init())) {
            SSButton(InventoryFilterConstants.filterButtonProperty) {
              inventoryStore.send(.didTapFilterButton)
            }
            .allowsHitTesting(false)
          }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(width: geometry.size.width, height: 32, alignment: .topLeading)
      .padding(.horizontal, InventoryFilterConstants.commonSpacing)
    }
  }

  public var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack {
        HeaderView(store: inventoryStore.scope(state: \.headerType, action: \.setHeaderView))
        Spacer()
          .frame(height: 16)

        makeFilterView()
          .frame(height: 32)
        makeEmptyView()
      }
      InventoryFloatingButton(floatingStore: inventoryStore.scope(state: \.floatingState, action: \.setFloatingView))
        .padding(.trailing, 20)
        .padding(.bottom, 20)

    }.safeAreaInset(edge: .bottom) {
      SSTabbar(store: inventoryStore.scope(state: \.tabbarType, action: \.setTabbarView))
        .background {
          Color.white
        }
        .ignoresSafeArea()
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
<<<<<<< HEAD:Projects/Feature/Inventory/Sources/InventoryMainView/InventoryView.swift
    }.navigationBarBackButtonHidden()
=======
    }
>>>>>>> 1e16bea909ceb558852ba5feeae8229a26a8da3b:Projects/App/Sources/Views/InventoryView.swift
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
