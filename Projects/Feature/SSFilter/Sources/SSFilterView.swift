//
//  SSFilterView.swift
//  SSfilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSLayout
import SwiftUI

public struct SSFilterView<Item: SSFilterItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SSFilterReducer<Item>>
  private let topSectionTitle: String
  private let textFieldPrompt: String

  // MARK: Init

  public init(
    store: StoreOf<SSFilterReducer<Item>>,
    topSectionTitle: String,
    textFieldPrompt: String
  ) {
    self.store = store
    self.topSectionTitle = topSectionTitle
    self.textFieldPrompt = textFieldPrompt
  }

  // MARK: Content

  @ViewBuilder
  private func makeTopSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(topSectionTitle)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray100)

      makeTopSearchSection()
      makeTopButtonSection()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeTopSearchSection() -> some View {
    if store.isSearchSection {
      HStack(alignment: .center, spacing: 0) {
        SSImage
          .commonSearch

        Spacer()
          .frame(width: 8)

        TextField(
          "",
          text: $store.textFieldText.sending(\.view.changeTextField),
          prompt: Text(textFieldPrompt).foregroundStyle(SSColor.gray60)
        )
        .frame(maxWidth: .infinity)
        .foregroundStyle(SSColor.gray100)

        Spacer()
          .frame(width: 8)

        if store.state.textFieldText != "" {
          SSImage
            .commonClose
            .onTapGesture {
              store.sendViewAction(.closeButtonTapped)
            }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .frame(maxWidth: .infinity, idealHeight: 36)
      .background(SSColor.gray20)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  @ViewBuilder
  private func makeTopButtonSection() -> some View {
    WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
      if store.textFieldText.isEmpty {
        makeTopNotFilteredTItems()
      } else {
        makeTopFilteredItems()
      }
    }
  }

  @ViewBuilder
  func makeTopNotFilteredTItems() -> some View {
    let selectedItems = store.ssFilterItemHelper.selectedItems
    ForEach(store.ssFilterItemHelper.selectableItems.prefix(20)) { item in
      let isSelected = selectedItems.contains(item)
      SSButton(
        .init(
          size: .xsh28,
          status: isSelected ? .active : .inactive,
          style: .lined,
          color: .black,
          buttonText: item.title
        )
      ) {
        store.sendViewAction(.tappedItem(item))
      }
    }
  }

  @ViewBuilder
  private func makeTopFilteredItems() -> some View {
    let selectedItems = store.ssFilterItemHelper.selectedItems
    ForEach(store.filterByTextField.prefix(20)) { item in
      let isSelected = selectedItems.contains(item)
      SSButton(
        .init(
          size: .xsh28,
          status: isSelected ? .active : .inactive,
          style: .lined,
          color: .black,
          buttonText: item.title
        )
      ) {
        store.sendViewAction(.tappedItem(item))
      }
    }
  }

  @ViewBuilder
  private func makeMiddleSection() -> some View {
    switch store.type {
    case .withDate:
      EmptyView()
    case .withSlider:
      if let store = store.scope(state: \.sliderReducer, action: \.scope.sliderReducer) {
        SSFilterWithSliderView(store: store)
          .padding(.horizontal, 16)
      }
    }
  }

  @ViewBuilder
  private func makeBottomButtonOfDeselectable() -> some View {
    WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
      makeSliderFilterButton()
      makeDateDeselectableItemView()

      ForEach(store.ssFilterItemHelper.selectedItems) { item in
        SSButton(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: item.title
          )
        ) {
          store.sendViewAction(.tappedItem(item))
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeDateDeselectableItemView() -> some View {
    if let selectedString = store.dateReducer?.dateProperty.selectedFilterDateTextString {
      SSButtonWithState(
        .init(
          size: .xsh28,
          status: .active,
          style: .filled,
          color: .orange,
          leftIcon: .none,
          rightIcon: .icon(SSImage.commonDeleteWhite),
          buttonText: selectedString
        )) {
          store.send(.scope(.dateReducer(.view(.tappedResetButton))))
        }
    }
  }

  @ViewBuilder
  private func makeSliderFilterButton() -> some View {
    if let sliderProperty = store.sliderReducer?.sliderProperty,
       sliderProperty.isInitialState == false {
      SSButton(
        .init(
          size: .xsh28,
          status: .active,
          style: .filled,
          color: .orange,
          rightIcon: .icon(SSImage.commonDeleteWhite),
          buttonText: sliderProperty.sliderRangeText
        )) {
          store.send(.scope(.sliderReducer(.view(.resetSliderProperty))))
        }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        makeTopSection()

        Spacer()
          .frame(height: 48)

        makeMiddleSection()
      }
    }
    .safeAreaPadding(.top, 24)
    .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
    .scrollIndicators(.hidden)
    .contentShape(Rectangle())
    .whenTapDismissKeyboard()
  }

  @ViewBuilder
  private func makeBottom() -> some View {
    VStack(spacing: 0) {
      makeBottomButtonOfDeselectable()
      HStack(spacing: 16) {
        makeResetButton()
        makeConfirmButton()
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(SSColor.gray10)
    }
  }

  @ViewBuilder
  private func makeResetButton() -> some View {
    HStack(alignment: .top, spacing: 8) {
      Button {
        store.send(.view(.reset))
      } label: {
        SSImage.commonRefresh
      }
    }
    .padding(10)
    .cornerRadius(100)
    .overlay(
      RoundedRectangle(cornerRadius: 100)
        .inset(by: 0.5)
        .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1))
  }

  @ViewBuilder
  private func makeConfirmButton() -> some View {
    SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
      store.send(.view(.tappedConfirmButton))
    }
  }

  public var body: some View {
    makeContentView()
      .navigationBarBackButtonHidden()
      .onAppear {
        store.send(.view(.onAppear(true)))
      }
      .safeAreaInset(edge: .bottom) {
        makeBottom()
      }
  }

  private enum Metrics {}

  private enum Constants {}
}
