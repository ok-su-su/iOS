//
//  SSDateSelectBottomSheet.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - SSDateSelectBottomSheetReducer

@Reducer
public struct SSDateSelectBottomSheetReducer: Sendable {
  public init() {}
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared var selectedDate: Date
    @Shared var isInitialStateOfDate: Bool
    var initialStartDate = Date(timeIntervalSince1970: -1_230_886_800)
    var initialEndDate = Date(timeIntervalSince1970: 1_924_905_600)
    var isOnAppear: Bool = false

    public init(
      selectedDate: Shared<Date>,
      isInitialStateOfDate: Shared<Bool>,
      restrictStartDate: Date? = nil,
      restrictEndDate: Date? = nil
    ) {
      _selectedDate = selectedDate
      _isInitialStateOfDate = isInitialStateOfDate
      if let restrictStartDate {
        initialStartDate = restrictStartDate
      }
      if let restrictEndDate {
        initialEndDate = restrictEndDate
      }
    }
  }

  public enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case reset
    case didTapConfirmButton
    case didSelectedStartDate(Date)
    case changeDatePickerProperty(State)
  }

  @Dependency(\.dismiss) var dismiss
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .reset:
        state.isInitialStateOfDate = true
        state.selectedDate = .now
        return .none
      case .didTapConfirmButton:
        state.isInitialStateOfDate = false
        return .run { [dismiss = dismiss] _ in
          await dismiss()
        }
      case let .didSelectedStartDate(date):
        state.isInitialStateOfDate = false
        state.selectedDate = date
        return .none
      case let .onAppear(appear):
        if !state.isOnAppear {
          state.isOnAppear = appear
          state.isInitialStateOfDate = true
        }
        return .none
      case let .changeDatePickerProperty(nextState):
        state = nextState
        return .none
      }
    }
  }
}

// MARK: - SSDateSelectBottomSheetView

public struct SSDateSelectBottomSheetView: View {
  @Bindable
  var store: StoreOf<SSDateSelectBottomSheetReducer>
  var isShowBottomFilterSectionView: Bool
  var bottomContent: AnyView?
  public init(
    store: StoreOf<SSDateSelectBottomSheetReducer>,
    isShowBottomFilterSectionView: Bool = true
  ) {
    self.store = store
    self.isShowBottomFilterSectionView = isShowBottomFilterSectionView
    bottomContent = nil
  }

  public init(
    store: StoreOf<SSDateSelectBottomSheetReducer>,
    @ViewBuilder bottomContent: () -> AnyView
  ) {
    self.store = store
    isShowBottomFilterSectionView = false
    self.bottomContent = bottomContent()
  }

  @ViewBuilder
  private func makeHandleView() -> some View {
    RoundedRectangle(cornerRadius: 100)
      .frame(width: 56, height: 6)
      .foregroundStyle(SSColor.gray20)
      .frame(height: 38)
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    HStack {
      ZStack {
        SSImage.commonRefresh
        RoundedRectangle(cornerRadius: 100)
          .inset(by: 0.5)
          .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
      }.onTapGesture {
        store.send(.reset)
      }
      .frame(width: 44, height: 44)

      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
        store.send(.didTapConfirmButton)
      }

    }.padding([.leading, .trailing], 16)
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    DatePicker(
      "",
      selection: $store.selectedDate.sending(\.didSelectedStartDate),
      in: store.initialStartDate ... store.initialEndDate,
      displayedComponents: [.date]
    )
    .datePickerStyle(.wheel)
    .labelsHidden()
    .environment(\.locale, Locale(identifier: Locale.current.language.languageCode?.identifier ?? "ko_kr"))
    .colorMultiply(SSColor.gray100)
    .applySSFont(.title_xxs)
    .preferredColorScheme(.light)
  }

  public var body: some View {
    ZStack(alignment: .center) {
      SSColor.gray10
      VStack(spacing: 0) {
        makeHandleView()
        Spacer()
        makeContentView()
        Spacer()
        if isShowBottomFilterSectionView {
          makeFilterContentView()
        }
        if let bottomContent {
          bottomContent
            .ignoresSafeArea()
        }
      }
    }
  }
}
