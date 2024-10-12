//
//  LedgerDetailFilterView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SSLayout
import SwiftUI

struct LedgerDetailFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LedgerDetailFilter>

  // MARK: Init

  init(store: StoreOf<LedgerDetailFilter>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeTopSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(Constants.topSectionTitle)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray100)

      makeTopSearchSection()

      makeTopButtonSection()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeTopSearchSection() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage
        .commonSearch

      Spacer()
        .frame(width: 8)

      TextField("", text: $store.textFieldText.sending(\.view.changeTextField), prompt: Constants.prompt.foregroundStyle(SSColor.gray60))
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
    ForEach(store.property.selectableItems.prefix(20)) { item in
      let isSelected = store.property.isSelectedItems(id: item.id)
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
    ForEach(store.filterByTextField.prefix(20)) { item in
      let isSelected = store.property.isSelectedItems(id: item.id)
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

  private func makeSelectedFilterContentView() -> some View {
    WrappingHStack(horizontalSpacing: 8) {
      ForEach(store.property.selectedItems) { item in
        SSButtonWithState(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            leftIcon: .none,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: item.title
          )) {
            store.sendViewAction(.tappedItem(item))
          }
      }
    }
  }

  @ViewBuilder
  /// ProgressView를 만듭니다.
  private func makeProgressView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(Constants.progressTitleText)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray100)

      VStack(alignment: .leading, spacing: 8) {
        Text(store.sliderRangeText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)

        SliderView(slider: store.sliderProperty)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func makeConfirmButton() -> some View {
    SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
      // MARK: - CustomSLider가 Reducer가 아니라 생명주기를 컨트롤하지 못하는 문제가 있습니다.

      // 따라서 ObservedObject를 활용하여 해결했습니다. 차후 빠르게 Reducer를 활용하는 slider를 만들겠습니다.
      store.sendViewAction(.tappedConfirmButton)
    }
  }

  @ViewBuilder
  private func makeResetButton() -> some View {
    HStack(alignment: .top, spacing: 8) {
      Button {
        store.sendViewAction(.reset)
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
  private func makeBottom() -> some View {
    HStack(spacing: 16) {
      makeResetButton()
      makeConfirmButton()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
  }

  @ViewBuilder
  private func makeBottomButtonOfDeselectable() -> some View {
    WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
      // Slider ResetButton
      makeSliderFilterButton()

      ForEach(store.property.selectedItems) { item in
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
  private func makeSliderFilterButton() -> some View {
    if !store.isInitialState {
      SSButton(
        .init(
          size: .xsh28,
          status: .active,
          style: .filled,
          color: .orange,
          rightIcon: .icon(SSImage.commonDeleteWhite),
          buttonText: store.sliderRangeText
        )) {
          store.sendViewAction(.tappedSliderResetButton)
        }
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 24)

      makeTopSection()

      Spacer()
        .frame(height: 48)

      makeProgressView()
        .padding(.horizontal, 16)

      Spacer()

      makeBottomButtonOfDeselectable()
      makeBottom()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let prompt: Text = .init("보낸 사람을 검색해보세요")
    static let progressTitleText: String = "받은 봉투 금액"
    static let topSectionTitle: String = "보낸 사람"
  }
}
