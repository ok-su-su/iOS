//
//  InventoryAccountDetailFilterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem
import SSLayout

// MARK: - InventoryAccountDetailFilterView

struct InventoryAccountDetailFilterView: View {
  @Bindable var store: StoreOf<InventoryAccountDetailFilter>

  @ObservedObject var sliderProperty: CustomSlider = .init(start: 0, end: 1_000_000, width: UIScreen.main.bounds.size.width - 32)

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      Text("보낸 사람")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .padding(.horizontal, 16)

      InvetoryAccountDetailFilterTextFieldView(store: store.scope(state: \.accountSearchTextField, action: \.detailTextField))
        .padding(.horizontal, 16)

      Spacer()
        .frame(height: 16)
    }
  }

  @ViewBuilder
  private func makePersonContentView() -> some View {
    VStack {
      WrappingHStack(horizontalSpacing: 4, verticalSpacing: 4) {
        ForEach(0 ..< store.accountFilterHelper.remitPerson.count, id: \.self) { id in
          SSButtonWithState(store.accountFilterHelper.ssButtonProperties[store.accountFilterHelper.remitPerson[id].id, default: Constants.buttonProperty]) {
            store.send(.didTapPerson(store.accountFilterHelper.remitPerson[id].id))
          }
        }
      }
      .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  private func makeSelectedPersonContentView() -> some View {
    WrappingHStack(horizontalSpacing: 4, verticalSpacing: 4) {
      ForEach(0 ..< store.accountFilterHelper.selectedPerson.count, id: \.self) { id in
        SSButton(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: store.accountFilterHelper.selectedPerson[id].name
          )
        ) {
          store.send(.didTapSelectedPerson(store.accountFilterHelper.selectedPerson[id].id))
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeProgressContentView() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("받은 봉투 금액")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .padding(.horizontal, 16)

      VStack(alignment: .leading, spacing: 8) {
        Text("\(sliderProperty.lowHandle.currentValueBy1000)원 ~ \(sliderProperty.highHandle.currentValueBy1000)원")
          .modifier(SSTypoModifier(.title_m))
          .padding(.horizontal, 16)

        HStack(spacing: 0) {
          SliderView(slider: sliderProperty)
        }
        .padding(.horizontal, 16)
      }
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeConfirmContentView() -> some View {
    HStack(spacing: 16) {
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
      .padding(.leading, 16)

      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
        store.send(.didTapConfirmButton)
      }
      .padding(.trailing, 16)
    }
    .frame(maxWidth: .infinity)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        HeaderView(store: store.scope(state: \.headerType, action: \.header))

        makeContentView()

        makePersonContentView()

        Spacer()
          .frame(height: 48)

        makeProgressContentView()

        Spacer()
        makeSelectedPersonContentView()

        Spacer()
          .frame(height: 8)
        makeConfirmContentView()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationBarBackButtonHidden()
  }

  private enum Constants {
    static let buttonProperty: SSButtonPropertyState = .init(
      size: .sh48,
      status: .active,
      style: .filled,
      color: .orange,
      buttonText: ""
    )
  }
}
