//
//  CreateEnvelopeDateView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

struct CreateEnvelopeDateView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeDate>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 20)

      HStack(spacing: 4) {
        // TODO: change Property
        Text("\(store.envelopeTargetName)님에게")
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.nameDescriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)

        Spacer()
      }
      .padding(.bottom, 12)

      HStack(spacing: 0) {
        Text(store.yearStringText)
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(store.isInitialStateOfDate ? SSColor.gray30 : SSColor.gray100)

        Text("년 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100)

        Text(store.monthStringText)
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(store.isInitialStateOfDate ? SSColor.gray30 : SSColor.gray100)

        Text("월 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100)

        Text(store.dayStringText)
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(store.isInitialStateOfDate ? SSColor.gray30 : SSColor.gray100)

        Text("일 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100)

        Spacer()
      }

      Spacer()
    }
    .onTapGesture {
      store.sendViewAction(.tappedDateSheet)
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
    }
    .nextButton(store.pushable) {
      store.sendViewAction(.tappedNextButton)
    }
    .showDatePickerWithNextButton(store: $store.scope(state: \.datePicker, action: \.scope.datePicker)) {
      store.sendViewAction(.tappedNextButton)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let nameDescriptionText: String = "언제 보냈나요"

    static let yearTextFieldTextPrompt: Text = .init("2024")
    static let monthTextFieldTextPrompt: Text = .init("11")
    static let dayTextFieldTextPrompt: Text = .init("24")
  }
}
