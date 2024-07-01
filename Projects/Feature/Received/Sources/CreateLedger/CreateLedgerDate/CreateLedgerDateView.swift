//
//  CreateLedgerDateView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

struct CreateLedgerDateView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateLedgerDate>

  // MARK: Init

  init(store: StoreOf<CreateLedgerDate>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      HStack(spacing: 4) {
        Text(store.titleText + "는/은")
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.titleDescriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)

        Spacer()
      }
      .padding(.bottom, 16)

      makeDateSectionView()
        .padding(.bottom, 32)

      makeDisplayTypeButton()

      Spacer()
    }
  }

  @ViewBuilder
  private func makeDateSectionView() -> some View {
    if store.displayType == .startDate {
      makeDateTextView(date: store.startSelectedDate, isInitialState: store.isInitialStateOfStartDate)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
          store.sendViewAction(.tappedStartDatePicker)
        }
    } else {
      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 8) {
          makeDateTextView(date: store.startSelectedDate, isInitialState: store.isInitialStateOfStartDate)
          Text("부터")
            .modifier(SSTypoModifier(.title_m))
            .foregroundStyle(SSColor.gray100)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
          store.sendViewAction(.tappedStartDatePicker)
        }

        HStack(spacing: 8) {
          makeDateTextView(date: store.endSelectedDate, isInitialState: store.isInitialStateOfEndDate)
          Text("까지")
            .modifier(SSTypoModifier(.title_m))
            .foregroundStyle(SSColor.gray100)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
          store.sendViewAction(.tappedEndDatePicker)
        }
      }
    }
  }

  @ViewBuilder
  private func makeDisplayTypeButton() -> some View {
    let buttonText = store.displayType == .startAndEndDate ? "시작일만 지정" : "종료일 추가"
    SSButton(
      .init(
        size: .sh40,
        status: .active,
        style: .ghost,
        color: .orange,
        buttonText: buttonText
      )) {
        store.sendViewAction(.tappedChangeDisplayTypeButton)
      }
  }

  @ViewBuilder
  private func makeDateTextView(date: Date, isInitialState: Bool) -> some View {
    let year = CustomDateFormatter.getYear(from: date)
    let month = CustomDateFormatter.getMonth(from: date)
    let day = CustomDateFormatter.getDay(from: date)
    HStack(spacing: 0) {
      Text(year)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(isInitialState ? SSColor.gray30 : SSColor.gray100)

      Text("년 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)

      Text(month)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(isInitialState ? SSColor.gray30 : SSColor.gray100)

      Text("월 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)

      Text(day)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(isInitialState ? SSColor.gray30 : SSColor.gray100)

      Text("일 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
          .padding(.horizontal, 16)
      }
    }
    .navigationBarBackButtonHidden()
    .modifier(SSDateBottomSheetModifier(store: $store.scope(state: \.datePicker, action: \.scope.datePicker)))
    .safeAreaInset(edge: .bottom) {
      NextButtonView(isPushable: store.pushable) {
        store.sendViewAction(.tappedNextButton)
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let titleDescriptionText = "언제인가요"
  }
}
