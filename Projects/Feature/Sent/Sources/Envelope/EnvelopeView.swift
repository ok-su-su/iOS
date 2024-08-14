//
//  EnvelopeView.swift
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
      // 이름
      Text(store.envelopeProperty.envelopeTargetUserNameText)
        .modifier(SSTypoModifier(.title_xs))
        .padding(.trailing, Metrics.textAndBadgeSpacing)
        .foregroundStyle(SSColor.gray100)
      // 전체 금액
      SSBadge(
        property: .init(
          size: .small,
          badgeString: store.envelopeProperty.totalPriceText,
          badgeColor: .gray20
        )
      )
      Spacer()

      // DetailView Button
      Button {
        store.send(.tappedDetailButton)
      } label: {
        makeDetailPressButton()
      }
    }
    .frame(height: 28)
  }

  @ViewBuilder
  private func makeDetailPressButton() -> some View {
    SSImage.envelopeDownArrow
      .frame(width: 24, height: 24)
      .rotationEffect(.degrees(store.showDetail ? 180 : 0))
  }

  @ViewBuilder
  private func makeDetailContentView(
    isSentType: Bool,
    eventNameTextString: String,
    dateTextString: String,
    priceTextString: String
  ) -> some View {
    if isSentType {
      HStack {
        HStack(spacing: 12) {
          SSImage.envelopeBackArrow
          SSBadge(property: .init(size: .small, badgeString: eventNameTextString, badgeColor: .gray90))
          Text(dateTextString)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.gray100)
        }
        Spacer()
        Text(priceTextString)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray100)
      }
    } else {
      HStack {
        HStack(spacing: 12) {
          SSImage.envelopeForwardArrow
          SSBadge(property: .init(size: .small, badgeString: eventNameTextString, badgeColor: .gray40))
          Text(dateTextString)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(SSColor.gray50)
        }
        Spacer()
        Text(priceTextString)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray50)
      }
    }
  }

  @ViewBuilder
  private func makeEnvelopeDetailView() -> some View {
    if store.showDetail {
      VStack(spacing: 8) {
        if store.isLoading {
          ForEach(0 ..< 3, id: \.self) { _ in
            makeDetailContentView(
              isSentType: false,
              eventNameTextString: "",
              dateTextString: "",
              priceTextString: ""
            )
          }
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
        } else {
          ForEach(store.envelopeProperty.envelopeContents) { property in
            makeDetailContentView(
              isSentType: property.isSentView,
              eventNameTextString: property.eventName,
              dateTextString: property.dateText,
              priceTextString: property.priceText
            )
          }
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

      VStack(spacing: Metrics.topAndMiddleSpacing) {
        makeHeaderView()
        EnvelopePriceProgressView(envelopePriceProgressProperty: store.envelopePriceProgressProperty)
      }
      .padding(Metrics.contentSpacing)
    }
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  var body: some View {
    VStack(spacing: 8) {
      makeEnvelopeTotalView()
        .onTapGesture {
          store.send(.tappedFullContentOfEnvelopeButton)
        }
      makeEnvelopeDetailView()
    }
    .onAppear {
      store.send(.isOnAppear(true))
    }
  }

  private enum Metrics {
    static let topRectangleHeight: CGFloat = 40
    static let topTriangleHeight: CGFloat = 24
    static let contentSpacing: CGFloat = 16

    static let textAndBadgeSpacing: CGFloat = 12

    static let topAndMiddleSpacing: CGFloat = 16

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
