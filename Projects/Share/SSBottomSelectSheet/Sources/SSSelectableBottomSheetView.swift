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
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      ScrollViewReader { value in
        ScrollView(showsIndicators: false) {
          Spacer()
            .frame(height: 16)
          VStack(spacing: 0) {
            // TODO: 블로그 작성
            ForEach(store.items) { item in
              Text(item.description)
                .modifier(SSTypoModifier(.title_xxs))
                .padding(.vertical, itemVerticalSpacing)
                .foregroundStyle(store.selectedItem == item ? SSColor.gray100 : SSColor.gray30)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  store.send(.tapped(item: item))
                }
                .id(item.id)
            }
          }
          .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .onAppear {
          value.scrollTo(store.selectedItem?.id, anchor: .center)
        }
      }
    }
  }

  public var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
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
