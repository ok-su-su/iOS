//
//  MyPageEditView.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

struct MyPageEditView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageEdit>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeProfileView()

      makeNameTextfieldItem()

      makeBirthDayItem()

      makeGenderItem()

      Spacer()
    }
  }

  @ViewBuilder
  private func makeProfileView() -> some View {
    SSImage
      .mypageSusu
      .frame(width: 88, height: 88)
      .clipShape(.circle)
      .padding(.vertical, Metrics.profileVerticalSpacing)
  }

  @ViewBuilder
  private func makeTabBar() -> some View {
    SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
      .background {
        Color.white
      }
      .ignoresSafeArea()
      .frame(height: 56)
      .toolbar(.hidden, for: .tabBar)
  }

  @ViewBuilder
  private func makeNameTextfieldItem() -> some View {
    HStack {
      HStack(alignment: .top, spacing: 4) {
        Text(Constants.nameCellTitle)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray60)

        VStack(spacing: 0) {
          Spacer()
            .frame(height: 4)
          SSColor
            .red60
            .clipShape(Circle())
            .frame(width: 4, height: 4)
        }
      }

      TextField(
        "",
        text: $store.nameTextFieldText.sending(\.view.nameEdited),
        prompt: nil
      )
      .modifier(SSTypoModifier(.title_xs))
      .foregroundStyle(SSColor.gray100)
      .multilineTextAlignment(.trailing)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .frame(maxWidth: .infinity, maxHeight: 28)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeBirthDayItem() -> some View {
    HStack(spacing: 0) {
      Text(Constants.birthdayCellTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)

      Spacer()
      Text(store.yearText + "년")
        .frame(maxWidth: .infinity, alignment: .trailing)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(store.selectedBottomSheetItem != nil ? SSColor.gray100 : SSColor.gray40)
    }
    .frame(maxWidth: .infinity, maxHeight: 28)
    .padding(.vertical, Metrics.itemVerticalSpacing)
    .onTapGesture {
      store.send(.view(.selectedYearItem(true)))
    }
  }

  @ViewBuilder
  private func makeGenderItem() -> some View {
    HStack(spacing: 0) {
      Text(Constants.genderCellTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)

      Spacer()
      HStack(spacing: 8) {
        ForEach(Gender.allCases, id: \.id) { gender in
          let isSelected = store.selectedGender == gender
          SSButton(
            .init(
              size: .sh32,
              status: isSelected ? .active : .inactive,
              style: .filled,
              color: .orange,
              buttonText: gender.description,
              frame: .init(maxWidth: 116)
            )
          ) {
            store.send(.view(.selectGender(gender)))
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 28)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        ZStack {
          HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          HStack {
            Spacer()
            Text(Constants.confirmButtonText)
              .modifier(SSTypoModifier(.title_xxs))
              .foregroundStyle(store.isPushable ? SSColor.gray100 : SSColor.gray50)
              .onTapGesture {
                store.sendViewAction(.tappedEditConfirmButton)
              }
          }
          .padding(.horizontal, 16)
        }

        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .modifier(SSSelectableBottomSheetModifier(store: $store.scope(state: \.bottomSheet, action: \.scope.bottomSheet)))
    .safeAreaInset(edge: .bottom) { makeTabBar() }
  }

  private enum Metrics {
    static let profileVerticalSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
    static let itemVerticalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let nameCellTitle: String = "이름"
    static let birthdayCellTitle: String = "생년월일"
    static let genderCellTitle: String = "성별"
    static let confirmButtonText: String = "확인"
  }
}
