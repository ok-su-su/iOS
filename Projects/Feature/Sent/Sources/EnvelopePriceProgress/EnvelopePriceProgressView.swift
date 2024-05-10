// 
//  EnvelopePriceProgressView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct EnvelopePriceProgressView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<EnvelopePriceProgress>
  
  @ViewBuilder
  private func makeMiddleView() -> some View {
    HStack {
      Text(Constants.middleLeadingButtonText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray90)

      Spacer()

      Text(Constants.middleTrailingButtonText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray60)
    }
  }

  @ViewBuilder
  private func makeProgressBarView() -> some View {
    ZStack(alignment: .topLeading) {
      SSColor.orange20
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      SSColor.orange60
        .frame(maxWidth: store.progressValue, maxHeight: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, maxHeight: Metrics.progressHeightValue)
    .clipShape(RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous))
    .padding(.vertical, Metrics.progressBarVerticalSpacing)
  }

  @ViewBuilder
  private func makeBottomView() -> some View {
    HStack {
      // TODO: API 호출 된 Value 로 변경
      Text("700,000원")
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray90)

      Spacer()

      // TODO: API 호출 된 Value 로 변경
      Text("1,000,000원")
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray60)
    }
  }
  
  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {

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
    .onAppear{
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {
    static let progressHeightValue: CGFloat = 4
    static let progressCornerRadius: CGFloat = 8
    static let progressBarVerticalSpacing: CGFloat = 4
  }
  
  private enum Constants {
    static let middleLeadingButtonText: String = "보내요"
    static let middleTrailingButtonText: String = "보내요"
  }
}
