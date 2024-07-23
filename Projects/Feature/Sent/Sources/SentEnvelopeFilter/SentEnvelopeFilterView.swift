//
//  SentEnvelopeFilterView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SSLayout
import SwiftUI

struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentEnvelopeFilter>

  @State
  var showSelectedSliderButton: Bool = false

  // MARK: Content

  @ViewBuilder
  private func makePersonButton() -> some View {
    let filteredPeople = store.filterByTextField
    let sentPeople = store.filterHelper.sentPeople
    if filteredPeople == [] && store.textFieldText == "" {
      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sentPeople) { person in
          let isSelected = store.filterHelper.isSelected(person)
          SSButton(
            .init(
              size: .xsh28,
              status: isSelected ? .active : .inactive,
              style: .lined,
              color: .black,
              buttonText: person.name
            )) {
              store.send(.tappedPerson(person))
            }
        }
      }
    } else {
      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(filteredPeople) { person in
          let isSelected = store.filterHelper.isSelected(person)
          SSButton(
            .init(
              size: .xsh28,
              status: isSelected ? .active : .inactive,
              style: .lined,
              color: .black,
              buttonText: person.name
            )) {
              store.send(.tappedPerson(person))
            }
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
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeBottomButtonOfDeselectable() -> some View {
    WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
      // Slider ResetButton
      makeSliderFilterButton()

      // FilterPeople ResetButton
      ForEach(store.filterHelper.selectedPerson) { person in
        SSButton(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: person.name
          )
        ) {
          store.send(.tappedPerson(person))
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func makeBottom() -> some View {
    HStack(spacing: 16) {
      makeResetButton()
      makeConfirmButton()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(SSColor.gray10)
  }

  @ViewBuilder
  private func makeResetButton() -> some View {
    HStack(alignment: .top, spacing: 8) {
      Button {
        store.send(.reset)
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
      store.send(.tappedConfirmButton)
    }
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
          store.send(.tappedSliderValueResetButton)
        }
    }
  }

  @ViewBuilder
  private func makeSendTap() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(Constants.searchTextFieldTitle)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray100)

      CustomTextFieldView(store: store.scope(state: \.customTextField, action: \.customTextField))
        .padding(.vertical, 16)

      makePersonButton()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  func makeContentView() -> some View {
    VStack(spacing: 48) {
      makeSendTap()
      Spacer()
        .frame(height: 48)
      makeProgressView()
      Spacer()
      VStack(alignment: .leading, spacing: 8) {
        makeBottomButtonOfDeselectable()
      }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.header))
          .padding(.bottom, 24)
        ScrollView {
          makeContentView()
        }
        .padding(.horizontal, 16)
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        .scrollIndicators(.hidden)
        .contentShape(Rectangle())
        .whenTapDismissKeyboard()
      }
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      makeBottom()
    }
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  // MARK: Init

  init(store: StoreOf<SentEnvelopeFilter>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {
    static let searchTextFieldTitle: String = "보낸 사람"
    static let progressTitleText: String = "전체 금액"
    static let butonProperty: SSButtonPropertyState = .init(size: .sh48, status: .active, style: .filled, color: .orange, buttonText: "   ")
  }
}
