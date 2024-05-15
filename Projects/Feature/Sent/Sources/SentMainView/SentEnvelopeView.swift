//
//  SentEnvelopeView.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - EnvelopeView

struct EnvelopeView: View {
  @Bindable
  var store: StoreOf<Envelope>

  @ViewBuilder
  private func makeHeaderView() -> some View {
    HStack(spacing: 0) {
      Text("김철수") // TODO:
        .modifier(SSTypoModifier(.title_xs))
        .padding(.trailing, Metrics.textAndBadgeSpacing)
      SmallBadge(property: .init(
        size: .small,
        badgeString: "전체: 1,700,000 원", // TODO:
        badgeColor: .gray20
      ))
      Spacer()

      Button {
        store.send(.tappedDetailButton)
      } label: {
        if store.showDetail == false {
          SSImage.envelopeDownArrow
        } else {
          SSImage.envelopeDownArrow
            .rotationEffect(.degrees(180))
        }
      }
    }
  }

  @ViewBuilder
  private func makeMiddleView() -> some View {
    HStack {
      Text(Metrics.middleLeadingButtonText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundColor(SSColor.gray90)

      Spacer()

      Text(Metrics.middleTrailingButtonText)
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

  @ViewBuilder
  private func makeDetailContentView(_ isHighlight: Bool) -> some View {
    if isHighlight {
      HStack {
        HStack(spacing: 12) {
          SSImage.envelopeBackArrow
          SmallBadge(property: .init(size: .small, badgeString: "돌잔치", badgeColor: .gray90)) // TODO: 수정
          Text("23.07.18") // TODO: 수정
            .modifier(SSTypoModifier(.title_xxxs))
        }
        Spacer()
        Text("50,000 원")
          .modifier(SSTypoModifier(.title_xxs))
      }
    } else {
      HStack {
        HStack(spacing: 12) {
          SSImage.envelopeForwardArrow
          SmallBadge(property: .init(size: .small, badgeString: "돌잔치", badgeColor: .gray40)) // TODO: 수정
          Text("23.07.18") // TODO: 수정
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.gray50)
        }
        Spacer()
        Text("50,000 원")
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray50)
      }
    }
  }

  @ViewBuilder
  private func makeEnvelopeDetailView() -> some View {
    if store.showDetail {
      VStack {
        ForEach(store.envelopeProperty.envelopeContents) { property in
          makeDetailContentView(property.isHighlight)
        }
        Spacer()
          .frame(height: 16)

        SSButton(
          .init(
            size: .xsh44,
            status: .active,
            style: .filled,
            color: .black,
            buttonText: "전체 보기",
            frame: .init(maxWidth: .infinity)
          )) {
            store.send(.tappedFullContentOfEnvelopeButton)
          }
      }
      .padding(.top, 24)
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
      .background {
        SSColor.gray10
      }
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  @ViewBuilder
  func makeEnvelopeTotalView() -> some View {
    ZStack {
      SSColor.gray10
      VStack(spacing: 0) {
        SSColor.orange5
          .frame(maxWidth: .infinity, maxHeight: Metrics.topRectangleHeight)

        CustomTriangle()
          .fill(SSColor.orange5)
          .frame(maxWidth: .infinity, maxHeight: Metrics.topTriangleHeight)
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      VStack(spacing: 0) {
        makeHeaderView()

        Spacer()
          .frame(height: Metrics.topAndMiddleSpacing)

        makeMiddleView()
        makeProgressBarView()
        makeBottomView()
      }
      .padding(Metrics.contentSpacing)
    }
    .frame(maxHeight: Metrics.viewMaxHeight)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  var body: some View {
    VStack(spacing: 0) {
      makeEnvelopeTotalView()
      Spacer()
        .frame(height: 8)
      makeEnvelopeDetailView()
    }
  }

  private enum Metrics {
    static let topRectangleHeight: CGFloat = 40
    static let topTriangleHeight: CGFloat = 24
    static let contentSpacing: CGFloat = 16

    static let textAndBadgeSpacing: CGFloat = 12

    static let detailButtonWidthAndHeight: CGFloat = 24

    static let middleLeadingButtonText: String = "보내요"
    static let middleTrailingButtonText: String = "보내요"

    static let topAndMiddleSpacing: CGFloat = 16

    static let progressCornerRadius: CGFloat = 8
    static let progressHeightValue: CGFloat = 4

    static let progressBarVerticalSpacing: CGFloat = 4

    static let viewMaxHeight: CGFloat = 124
  }
}

// MARK: - CustomTriangle

struct CustomTriangle: Shape {
  var startValue: CGFloat = 9 / 36
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: .init(x: 0, y: 0))
    path.addLine(to: .init(x: 0, y: startValue))
    path.addLine(to: .init(x: rect.size.width / 2, y: rect.size.height))
    path.addLine(to: .init(x: rect.size.width, y: startValue))
    path.addLine(to: .init(x: rect.size.width, y: 0))
    path.closeSubpath()

    return path
  }
}