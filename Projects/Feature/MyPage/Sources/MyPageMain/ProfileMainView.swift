//
//  ProfileMainView.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyPageMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView {
      VStack(spacing: 8) {
        makeMyNameAndMyInformationButtonView()
        makeTopSection()
        makeMiddleSection()
      }
    }
  }

  @ViewBuilder
  private func makeTopSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.topSectionList, action: \.scope.topSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeMiddleSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.middleSectionList, action: \.scope.middleSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeBottomSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.bottomSectionList, action: \.scope.bottomSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeMyNameAndMyInformationButtonView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      Text("김수수") // TODO: logic 연결
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()

      HStack(alignment: .center, spacing: 8) {
        Text(Constants.myInformationText)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray60)

        SSImage
          .envelopeForwardArrow
      }
    }
    .padding(.vertical, Metrics.makeMyNameAndMyInformationButtonViewVerticalSpacing)
    .frame(maxWidth: .infinity)
    .background(SSColor.gray10)
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

  var body: some View {
    ZStack {
      SSColor
        .gray20
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .safeAreaInset(edge: .bottom) { makeTabBar() }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let makeMyNameAndMyInformationButtonViewVerticalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let myInformationText: String = "내정보"
  }
}
