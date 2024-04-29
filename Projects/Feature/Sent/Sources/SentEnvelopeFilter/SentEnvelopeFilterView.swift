//
//  SentEnvelopeFilterView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SentEnvelopeFilterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SentEnvelopeFilter>

  @ObservedObject
  var sliderProperty: CustomSlider = .init(start: 0, end: 100_000, width: UIScreen.main.bounds.size.width - 42)

  // MARK: Content

  @ViewBuilder
  private func makePersonButton() -> some View {
    ForEach(0 ..< store.sentPeople.count, id: \.self) { index in
      if index % 5 == 0 {
        GridRow {
          ForEach(index ..< min(index + 5, store.sentPeople.count), id: \.self) { innerIndex in
            SSButtonWithState(store.ssButtonProperties[innerIndex]) {
              store.send(.tappedPerson(innerIndex))
            }
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
    VStack {
      ForEach(store.selectedSentPerson, id: \.id) { person in
        SSButton(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            buttonText: person.name
          )) {
            store.send(.tappedSelectedPerson(person.id))
          }
      }
    }
  }

  @ViewBuilder
  private func makeSendTap() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(Constants.searchTextFieldTitle)
        .modifier(SSTypoModifier(.title_xs))
      SSTextField(isDisplay: false, text: $store.textFieldText, property: .account, isHighlight: $store.isHighlight)
      Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
        makePersonButton()
      }
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
      makeSelectedPeople()
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
  }
}
