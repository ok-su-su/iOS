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

  var body: some View {
    VStack {
      ZStack {
        ZStack {
          SSColor.gray10
          VStack(spacing: 0) {
            SSColor.red100
              .frame(maxWidth: .infinity, maxHeight: Constants.topRectangleHeight)

            CustomTriangle()
              .fill(SSColor.red100)
              .frame(maxWidth: .infinity, maxHeight: Constants.topTriangleHeight)
            Spacer()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      VStack {
        HStack {
          Text("김철수")
            .padding(.trailing, Constants.textAndBadgeSpacing)
          SmallBadge(property: .init(
            size: .small,
            badgeString: store.envelopeProperty.id.description,
            badgeColor: .gray20
          )
          )
          Spacer()

          Button {
            store.send(.tappedDetailButton)
          } label: {
            SSImage.envelopeDownArrow
              .resizable()
          }
          .frame(
            width: Constants.detailButtonWidthAndHeight,
            height: Constants.detailButtonWidthAndHeight
          )
        }

        EmptyView()
          .frame(height: Constants.topAndMiddleSpacing)

        HStack {
          Text(Constants.middleLeadingButtonText)
            .modifier(SSTypoModifier(.text_xxxs))
            .foregroundColor(SSColor.gray90)

          Spacer()

          Text(Constants.middleTrailingButtonText)
            .modifier(SSTypoModifier(.text_xxxs))
            .foregroundColor(SSColor.gray60)
        }

        ZStack {
          SSColor.orange20
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          SSColor.orange60
            .frame(maxWidth: store.progressValue, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.progressHeightValue)
        .clipShape(RoundedRectangle(cornerRadius: Constants.progressCornerRadius, style: .continuous))
        .padding(.vertical, Constants.progressBarVerticalSpacing)

        HStack {
          Text("700,000원")
            .modifier(SSTypoModifier(.text_xxxs))
            .foregroundColor(SSColor.gray90)

          Spacer()

          Text("1,000,000원")
            .modifier(SSTypoModifier(.text_xxxs))
            .foregroundColor(SSColor.gray60)
        }
      }
      .padding(Constants.contentSpacing)
      Text("asdf")
      Text("HelloWorld")
    }
  }

  private enum Constants {
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
