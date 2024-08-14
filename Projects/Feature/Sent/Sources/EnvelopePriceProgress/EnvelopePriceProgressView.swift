//
//  EnvelopePriceProgressView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct EnvelopePriceProgressView: View {
  // MARK: Reducer

  var envelopePriceProgressProperty: EnvelopePriceProgressProperty

  @ViewBuilder
  private func makeMiddleView() -> some View {
    HStack {
      Text(envelopePriceProgressProperty.leadingDescriptionText)
        .applySSFont(.title_xxxs)
        .foregroundColor(SSColor.gray90)

      Spacer()

      Text(envelopePriceProgressProperty.trailingDescriptionText)
        .applySSFont(.title_xxxs)
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
            maxWidth: geometry.size.width * envelopePriceProgressProperty.progressValue,
            maxHeight: geometry.size.height,
            alignment: .leading
          )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: Metrics.progressHeightValue)
    .clipShape(RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous))
  }

  @ViewBuilder
  private func makeBottomView() -> some View {
    HStack {
      Text(envelopePriceProgressProperty.leadingPriceText)
        .applySSFont(.title_xxxs)
        .foregroundColor(SSColor.gray90)

      Spacer()

      Text(envelopePriceProgressProperty.trailingPriceText)
        .applySSFont(.title_xxxs)
        .foregroundColor(SSColor.gray60)
    }
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 4) {
      makeMiddleView()
      makeProgressBarView()
      makeBottomView()
    }
  }

  var body: some View {
    makeContentView()
  }

  private enum Metrics {
    static let progressHeightValue: CGFloat = 4
    static let progressCornerRadius: CGFloat = 8
    static let progressBarVerticalSpacing: CGFloat = 4
  }
}
