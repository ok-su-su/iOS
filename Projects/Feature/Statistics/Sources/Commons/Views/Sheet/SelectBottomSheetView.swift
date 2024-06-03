//
//  SelectBottomSheetView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SelectBottomSheetView<Item: SelectBottomSheetPropertyItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SelectBottomSheet<Item>>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      ScrollView {
        Spacer()
          .frame(height: 16)
        LazyVStack(spacing: 0) {
          ForEach(store.property.items) { item in
            Text(item.description)
              .modifier(SSTypoModifier(.title_xxs))
              .padding(.vertical, itemVerticalSpacing)
              .onTapGesture {
//                store.send(.tappedYear(item.dateTitle))
              }
          }
        }
      }
    }
  }

  var body: some View {
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

  private enum Constants {}
}
