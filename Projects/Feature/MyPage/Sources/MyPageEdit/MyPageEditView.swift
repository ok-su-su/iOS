//
//  MyPageEditView.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
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
      Text(Constants.nameCellTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)

      Spacer()
      TextField(
        "",
        text: $store.helper.editedValue.name.sending(\.view.nameEdited),
        prompt: Text(store.helper.namePromptText).foregroundStyle(SSColor.gray40)
      )
      .modifier(SSTypoModifier(.title_xs))
      .foregroundStyle(SSColor.gray100)
      .multilineTextAlignment(.trailing)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  @ViewBuilder
  private func makeBirthDayItem() -> some View {
    HStack(spacing: 0) {
      Text(Constants.birthdayCellTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)

      Spacer()
      Text(store.helper.birthDayText)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(store.helper.isEditedBirthDay() ? SSColor.gray100 : SSColor.gray40)
    }
    .frame(maxWidth: .infinity)
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
          let isSelected = store.helper.selectedGender == gender
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
    .padding(.vertical, Metrics.itemVerticalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .sheet(isPresented: $store.selectYearIsPresented.sending(\.view.selectedYearItem)) {
      IfLetStore(store.scope(state: \.selectYear, action: \.scope.selectYear)) { store in
        SelectYearBottomSheetView(store: store)
          .presentationDetents([.height(240), .medium, .large])
          .presentationContentInteraction(.scrolls) // TODO: PR에 작성하기
          .presentationDragIndicator(.automatic)
      }
    }
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
  }
}
