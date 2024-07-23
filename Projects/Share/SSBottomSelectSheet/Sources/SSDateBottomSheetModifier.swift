//
//  SSDateBottomSheetModifier.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - SSDateBottomSheetModifier

public struct SSDateBottomSheetModifier: ViewModifier {
  public init(store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>) {
    _store = store
  }

  @Binding var store: StoreOf<SSDateSelectBottomSheetReducer>?
  @State var sheetContentHeight: CGFloat = 0

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSDateSelectBottomSheetView(store: store)
          .background(
            GeometryReader { proxy in
              Color.clear
                .task {
                  sheetContentHeight = proxy.size.height
                }
            }
          )
          .addBottomSheetSettings(contentHeight: sheetContentHeight)
      }
  }
}

// MARK: - showDatePickerWithBottomViewModifier

public struct showDatePickerWithBottomViewModifier<BottomView: View>: ViewModifier {
  var bottomView: BottomView
  @State var sheetContentHeight: CGFloat = 0
  public init(
    store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>,
    @ViewBuilder bottomView: () -> BottomView
  ) {
    _store = store
    self.bottomView = bottomView()
  }

  @Binding var store: StoreOf<SSDateSelectBottomSheetReducer>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSDateSelectBottomSheetView(store: store) {
          AnyView(bottomView)
        }
        .background(
          GeometryReader { proxy in
            Color.clear
              .task {
                sheetContentHeight = proxy.size.height
              }
          }
        )
        .addBottomSheetSettings(contentHeight: sheetContentHeight)
      }
  }
}

public extension View {
  func showDatePicker(store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>) -> some View {
    modifier(SSDateBottomSheetModifier(store: store))
  }

  func showDatePickerWithBottomView(
    store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>,
    @ViewBuilder bottomView: () -> some View
  ) -> some View {
    modifier(showDatePickerWithBottomViewModifier(store: store, bottomView: {
      bottomView()
    }))
  }
}

private extension View {
  func addBottomSheetSettings(contentHeight: CGFloat = 343) -> some View {
    presentationDetents([.height(contentHeight), .medium, .large])
      .presentationContentInteraction(.scrolls)
      .presentationDragIndicator(.automatic)
      .presentationDragIndicator(.hidden)
  }
}
