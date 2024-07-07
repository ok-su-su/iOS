//
//  LedgerDetailEditView.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSEditSingleSelectButton
import SwiftUI

struct LedgerDetailEditView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LedgerDetailEdit>

  // MARK: Init

  init(store: StoreOf<LedgerDetailEdit>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeNameEditableSection()

      makeEventEditableSection()

      makeDateEditableSection()
    }
  }

  @ViewBuilder
  private func makeNameEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text("경조사 명")
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      TextField("", text: $store.editProperty.nameEditProperty.textFieldText.sending(\.view.changeNameTextField), prompt: nil)
        .frame(maxWidth: .infinity)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray70)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }

  @ViewBuilder
  private func makeEventEditableSection() -> some View {
    SingleSelectButtonView(store: store.scope(state: \.categorySection, action: \.scope.categorySection))
      .padding(.vertical, 16)
  }

  @ViewBuilder
  private func makeDateEditableSection() -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text("날짜")
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72, alignment: .leading)
        .foregroundStyle(SSColor.gray70)

      makeDatePickerDescriptionView()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }

  @ViewBuilder
  private func makeDatePickerDescriptionView() -> some View {
    let (startYear, startMonth, startDay) = store.startDateText
    let (endYear, endMonth, endDay) = store.endDateText ?? (nil, nil, nil)
    let (startSubFixString, endSubFixString) = endYear == nil ? (nil, nil) : ("부터", "까지")
    let dateToggleButtonText: String = endYear == nil ? "종료일 추가" : "시작일만 지정"

    VStack(alignment: .leading, spacing: 0) {
      makeYearMonthDayView(year: startYear, month: startMonth, day: startDay, subFixText: startSubFixString)
        .onTapGesture {
          store.sendViewAction(.tappedStartDatePickerButton)
        }

      if let endYear, let endMonth, let endDay {
        makeYearMonthDayView(year: endYear, month: endMonth, day: endDay, subFixText: endSubFixString)
          .onTapGesture {
            store.sendViewAction(.tappedEndDatePickerButton)
          }
      }

      SSButtonWithState(
        .init(
          size: .xsh28,
          status: .active,
          style: .lined,
          color: .orange,
          buttonText: dateToggleButtonText
        )) {
          store.sendViewAction(.tappedDateToggleButton)
        }
        .padding(.top, 8)
    }
  }

  @ViewBuilder
  func makeYearMonthDayView(year: String, month: String, day: String, subFixText _: String? = nil) -> some View {
    HStack(alignment: .center, spacing: .zero) {
      Text(year)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)

      Text("년 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray80)

      Text(month)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)

      Text("월 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray80)

      Text(day)
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray100)

      Text("일 ")
        .modifier(SSTypoModifier(.title_xl))
        .foregroundStyle(SSColor.gray80)
    }
  }

  @ViewBuilder
  private func makeSaveButton() -> some View {
    Button {
      store.sendViewAction(.tappedSaveButton)
    } label: {
      Text("저장")
        .applySSFont(.title_xs)
        .foregroundStyle(SSColor.blue10)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(store.isValid ? SSColor.gray100 : SSColor.gray30)
    }
    .disabled(!store.isValid)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, 16)
      }
    }
    .safeAreaInset(edge: .bottom) {
      makeSaveButton()
    }
    .showDatePicker(store: $store.scope(state: \.datePicker, action: \.scope.datePicker))
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
