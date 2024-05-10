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
import SwiftUI

struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentEnvelopeFilter>

  @State
  var showSelectedSliderButton: Bool = false

  @ObservedObject
  var sliderProperty: CustomSlider = .init(start: 0, end: 100_000, width: UIScreen.main.bounds.size.width - 65)

  var filterProperty: FilterProperty? {
    if store.state.filterHelper.selectedPerson == [] || sliderProperty.isInitialState() {
      return nil
    }
    return .init(
      filteredPeople: store.state.filterHelper.selectedPerson,
      filterEnvelopePrice: .init(maximum: sliderProperty.highHandle.currentValueBy1000, minimum: sliderProperty.lowHandle.currentValueBy1000)
    )
  }

  // MARK: Content

  @ViewBuilder
  private func makePersonButton() -> some View {
    let filteredPeople = store.filterByTextField
    let sentPeople = store.filterHelper.sentPeople
    if filteredPeople == [] && store.textFieldText == "" {
      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(0 ..< sentPeople.count, id: \.self) { index in
          let current = sentPeople[index]
          SSButtonWithState(store.filterHelper.ssButtonProperties[current.id, default: Constants.butonProperty]) {
            store.send(.tappedPerson(current.id))
          }
        }
      }
    } else {
      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(0 ..< filteredPeople.count, id: \.self) { index in
          let current = filteredPeople[index]
          SSButtonWithState(store.filterHelper.ssButtonProperties[current.id, default: Constants.butonProperty]) {
            store.send(.tappedPerson(current.id))
          }
        }
      }
    }
  }

  @ViewBuilder
  private func makeProgressView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(Constants.progressTitleText)
        .modifier(SSTypoModifier(.title_xs))
      VStack(alignment: .leading, spacing: 8) {
        Text("\(sliderProperty.lowHandle.currentValueBy1000)원 ~ \(sliderProperty.highHandle.currentValueBy1000)원")
          .modifier(SSTypoModifier(.title_m))

        HStack(spacing: 0) {
          SliderView(slider: sliderProperty)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeSelectedPeople() -> some View {
    WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
      ForEach(0 ..< store.filterHelper.selectedPerson.count, id: \.self) { index in
        if index < store.filterHelper.selectedPerson.count {
          let person = store.filterHelper.selectedPerson[index]
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
            store.send(.tappedSelectedPerson(person.id))
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func makeBottom() -> some View {
    HStack(spacing: 16) {
      HStack(alignment: .top, spacing: 8) {
        Button {
          sliderProperty.reset()
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

      ZStack {
        SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {}
      }
    }
    .padding(.vertical, 8)
  }

  @ViewBuilder
  private func makeSliderFilterButton() -> some View {
    if !sliderProperty.isInitialState() {
      SSButton(
        .init(
          size: .xsh28,
          status: .active,
          style: .filled,
          color: .orange,
          rightIcon: .icon(SSImage.commonDeleteWhite),
          buttonText: "\(sliderProperty.lowHandle.currentValueBy1000)원 ~ \(sliderProperty.highHandle.currentValueBy1000)원"
        )) {
          sliderProperty.reset()
        }
    }
  }

  @ViewBuilder
  private func makeSendTap() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(Constants.searchTextFieldTitle)
        .modifier(SSTypoModifier(.title_xs))

      CustomTextFieldView(store: store.scope(state: \.customTextField, action: \.customTextField))
        .padding(.vertical, 16)

      makePersonButton()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  func makeContentView() -> some View {
    VStack {
      makeSendTap()
      Spacer()
        .frame(height: 48)
      makeProgressView()
      Spacer()
      VStack(alignment: .leading, spacing: 8) {
        makeSliderFilterButton()
        makeSelectedPeople()
      }
      makeBottom()
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.header, action: \.header))
        makeContentView()
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.horizontal, 16)
    }
    .navigationBarBackButtonHidden()
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
