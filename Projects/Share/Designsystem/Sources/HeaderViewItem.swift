//
//  HeaderViewItem.swift
//  Designsystem
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

extension HeaderView {
  private enum Constants {
    static let headerLeftMargin: CGFloat = 10

    static let progressCornerRadius: CGFloat = 4
    static let progressMaxWidth: CGFloat = 96

    static let buttonWidthAndHeight: CGFloat = 44
    static let imagePadding: CGFloat = 10
  }

  @ViewBuilder
  func makeLeadingItem(isImage: Bool) -> some View {
    if isImage {
      Image(.commonLogo)
        .resizable()
        .scaledToFit()
        .frame(width: 56, height: 24, alignment: .leading)
        .padding(.leading, Constants.headerLeftMargin)
    } else {
      Button {
        store.send(.tappedDismissButton)
      } label: {
        Image(.commonArrow)
      }
      .frame(width: 56, height: 24, alignment: .leading)
      .padding(.leading, Constants.headerLeftMargin)
    }
  }

  func progressValue(_ value: Double) -> CGFloat {
    return min(Constants.progressMaxWidth * value, Constants.progressMaxWidth)
  }

  enum CenterItemTypes {
    case text(String)
    case progress(Double)
  }

  @ViewBuilder
  func makeCenterItem(type: CenterItemTypes) -> some View {
    switch type {
    case let .text(text):
      Text(text)
        .modifier(SSTypoModifier(.title_xs))
        .frame(maxWidth: .infinity, alignment: .center)
    case let .progress(degree):
      ZStack(alignment: .topLeading) {
        Color.orange30
          .frame(width: 96, height: 4, alignment: .center)
        Color.orange60
          .frame(width: progressValue(degree), alignment: .leading)
      }
      .frame(width: 96, height: 4)
      .clipShape(.rect(cornerRadius: Constants.progressCornerRadius))
      .padding(0)
    }
  }

  enum trailingItemTypes {
    case icon
    case none
    case text(String)
  }

  @ViewBuilder
  func makeTrailingItem(type: trailingItemTypes) -> some View {
    switch type {
    case .icon:
      HStack(spacing: 0) {
        Button {
          store.send(.tappedNotificationButton)
        } label: {
          SSImage.commonSearch
            .padding(Constants.imagePadding)
        }
        .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)

        Button {
          store.send(.tappedSearchButton)
        } label: {
          SSImage.commonSearch
            .padding(Constants.imagePadding)
        }
        .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)
      }
      .frame(alignment: .trailing)
    case .none:
      EmptyView()
    case let .text(text):
      Text(text)
        .modifier(SSTypoModifier(.title_xxs))
        .padding(Constants.imagePadding)
        .frame(alignment: .trailing)
        .onTapGesture {
          store.send(.tappedTextButton)
        }
    }
  }
}
