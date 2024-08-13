//
//  SSSelectableBottomSheetView.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SSSelectableBottomSheetView<Item: SSSelectBottomSheetPropertyItemable>: View {
  public init(store: StoreOf<SSSelectableBottomSheetReducer<Item>>) {
    self.store = store
  }

  @Bindable
  var store: StoreOf<SSSelectableBottomSheetReducer<Item>>

  // MARK: Content

  @ViewBuilder
  private func makeCellContentView() -> some View {
    ForEach(store.items) { item in
      Text(item.description)
        .applySSFont(.title_xxs)
        .padding(.vertical, itemVerticalSpacing)
        .foregroundStyle(store.selectedItem == item ? SSColor.gray100 : SSColor.gray30)
        .frame(maxWidth: .infinity)
        .onTapGesture {
          store.send(.tapped(item: item))
        }
        .id(item.id)
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollViewReader { value in
      ScrollView(showsIndicators: false) {
        ZStack {
          Spacer().containerRelativeFrame([.horizontal, .vertical])

          VStack(alignment: .center, spacing: 0) {
            makeCellContentView()
          }
          .scrollTargetLayout()
        }
      }
      .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
      .scrollTargetBehavior(.viewAligned)
      .onAppear {
        value.scrollTo(store.selectedItem?.id, anchor: .center)
      }
    }
  }

  @ViewBuilder
  private func makeHandleView() -> some View {
    RoundedRectangle(cornerRadius: 100)
      .frame(width: 56, height: 6)
      .foregroundStyle(SSColor.gray20)
      .frame(height: 38)
      .background(SSColor.gray10)
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
  }

  public var body: some View {
    ZStack(alignment: .center) {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeHandleView()
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private let itemVerticalSpacing: CGFloat = 12
}
