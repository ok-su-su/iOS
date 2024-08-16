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
import SSEditSingleSelectButton
import SSToast
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
            .opacity(store.isNameValid ? 0 : 1)
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
      Text(store.yearText)
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
    if let selectableStore = store.scope(state: \.genderSection, action: \.scope.genderSection) {
      SingleSelectButtonView(store: selectableStore, ssButtonFrame: .init(maxWidth: 116), isOneLine: true, titleTextColor: SSColor.gray60)
    }
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
              .disabled(!store.isPushable)
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
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .selectableBottomSheet(store: $store.scope(state: \.bottomSheet, action: \.scope.bottomSheet), cellCount: 5)
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
    static let confirmButtonText: String = "등록"
  }
}
