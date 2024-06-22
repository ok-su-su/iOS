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
public struct SSDateSelectBottomSheetReducer {
  @ObservableState
  public struct State {
    @Shared var selectedDate: Date?
    var initialStartDate = Date.now
    var initialEndDate = Calendar.current.date(byAdding: .year, value: 1, to: .now)!
  }

  public enum Action: Equatable {
    case reset
    case didTapConfirmButton
    case didSelectedStartDate(Date)
  }

  @Dependency(\.dismiss) var dismiss
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .reset:
        state.selectedDate = nil
        return .none
      case .didTapConfirmButton:
        return .run { _ in
          await dismiss()
        }
      case let .didSelectedStartDate(date):
        state.selectedDate = date
        return .none
      }
    }
  }
}

// MARK: - SSDateSelectBottomSheetView

public struct SSDateSelectBottomSheetView: View {
  @Bindable
  var store: StoreOf<SSDateSelectBottomSheetReducer>
  public init(store: StoreOf<SSDateSelectBottomSheetReducer>) {
    self.store = store
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    HStack {
      ZStack {
        SSImage.commonRefresh
      }.onTapGesture {
        store.send(.reset)
      }
      .padding(10)
      .overlay {
        RoundedRectangle(cornerRadius: 100)
          .inset(by: 0.5)
          .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
      }
      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
        store.send(.didTapConfirmButton)
      }

    }.padding([.leading, .trailing], 16)
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    GeometryReader { geometry in
      VStack(alignment: .leading) {
        DatePicker("", selection: $store.initialStartDate.sending(\.didSelectedStartDate), in: store.initialStartDate ... store.initialEndDate, displayedComponents: [.date])
          .clipped()
          .frame(maxWidth: .infinity)
          .datePickerStyle(.wheel)
          .labelsHidden()
          .environment(\.locale, Locale(identifier: Locale.current.language.languageCode?.identifier ?? "ko-kr"))
          .padding()
          .colorMultiply(SSColor.gray100)
          .font(.custom(.title_xxs))

      }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
    }.edgesIgnoringSafeArea(.all)
  }

  public var body: some View {
    VStack {
      makeContentView()
      makeFilterContentView()
    }
  }
}
