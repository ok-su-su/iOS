//
//  SelectYearBottomSheetView.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SelectYearBottomSheetView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SelectYearBottomSheet>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(store.listItems.items) { item in
            Text(item.dateTitle)
              .foregroundStyle(item.dateTitle == store.originalYearString ? SSColor.gray100 : SSColor.gray30)
              .padding(.vertical, Metrics.itemVerticalSpacing)
              .onTapGesture {
                store.send(.tappedYear(item.dateTitle))
              }
          }
        }
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {}
  }

  private enum Metrics {
    static let itemVerticalSpacing: CGFloat = 12
  }

  private enum Constants {}
}
