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
      Text(store.envelopePriceProgressProperty.leadingDescriptionText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray90)

      Spacer()

      Text(store.envelopePriceProgressProperty.trailingDescriptionText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray60)
    }
  }

  @ViewBuilder
  private func makeProgressBarView() -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .topLeading) {
        
        SSColor.orange20
          .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        SSColor.orange60
          .frame(
            maxWidth: geometry.size.width * store.envelopePriceProgressProperty.progressValue,
            maxHeight: geometry.size.height,
            alignment: .leading
          )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: Metrics.progressHeightValue)
    .clipShape(RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous))
    .padding(.vertical, Metrics.progressBarVerticalSpacing)
  }

  @ViewBuilder
  private func makeBottomView() -> some View {
    HStack {
      // TODO: API 호출 된 Value 로 변경
      Text(store.envelopePriceProgressProperty.leadingPriceText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray90)

      Spacer()

      // TODO: API 호출 된 Value 로 변경
      Text(store.envelopePriceProgressProperty.trailingPriceText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray60)
    }
  }
  
  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      makeMiddleView()
      makeProgressBarView()
      makeBottomView()
    }
    
    
  }

  var body: some View {
    makeContentView()
    .onAppear{
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {
    static let progressHeightValue: CGFloat = 4
    static let progressCornerRadius: CGFloat = 8
    static let progressBarVerticalSpacing: CGFloat = 4
  }
  
}
