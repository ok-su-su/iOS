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

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSDateSelectBottomSheetView(store: store)
          .presentationDetents([.height(282), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.automatic)
      }
  }
}

// MARK: - showDatePickerWithNextButtonModifier

public struct showDatePickerWithNextButtonModifier: ViewModifier {
  let nextButtonAction: () -> Void

  /// 다음 버튼이 있는 DatePicker를 만듭니다.
  /// - Parameters:
  ///   - store:present된 StoreOf<SSDateSelectBottomSheetReducer>?
  ///   - nextButtonAction: 반드시 datePicker가 dsimiss되는 Action을 포함시켜야 합니다.
  public init(
    store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>,
    nextButtonAction: @escaping () -> Void
  ) {
    _store = store
    self.nextButtonAction = nextButtonAction
  }

  @Binding var store: StoreOf<SSDateSelectBottomSheetReducer>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSDateSelectBottomSheetWithNextButtonView(store: store, completion: nextButtonAction)
          .presentationDetents([.height(282), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.automatic)
      }
  }
}

// MARK: - showDatePickerWithBottomViewModifier

public struct showDatePickerWithBottomViewModifier<BottomView: View>: ViewModifier {
  var bottomView: BottomView
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
        SSDateSelectBottomSheetView(store: store, isShowBottomFilterSectionView: false)
          .presentationDetents([.height(282), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.automatic)
          .safeAreaInset(edge: .bottom) {
            bottomView
          }
      }
  }
}

public extension View {
  func showDatePicker(store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>) -> some View {
    modifier(SSDateBottomSheetModifier(store: store))
  }

  func showDatePickerWithNextButton(
    store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>,
    tapped: @escaping () -> Void
  ) -> some View {
    modifier(showDatePickerWithNextButtonModifier(store: store, nextButtonAction: tapped))
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
