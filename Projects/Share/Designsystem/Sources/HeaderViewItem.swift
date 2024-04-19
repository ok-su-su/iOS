//
//  HeaderViewItem.swift
//  Designsystem
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - LeadingItem

struct LeadingItem: View {
  var isImage: Bool
  var body: some View {
    if isImage {
      Image(.commonLogo)
        .resizable()
        .scaledToFit()
        .frame(width: 56, height: 24, alignment: .leading)
        .padding(.leading, Constants.headerLeftMargin)
    } else {
      Button {} label: {
        Image(.commonArrow)
      }
      .frame(width: 56, height: 24, alignment: .leading)
      .padding(.leading, Constants.headerLeftMargin)
    }
  }

  private enum Constants {
    static let headerLeftMargin: CGFloat = 10
  }
}

// MARK: - CenterItem

struct CenterItem: View {
  enum Types {
    case text(String)
    case progress(Double)
  }

  var type: Types
  var body: some View {
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

  func progressValue(_ value: Double) -> CGFloat {
    return min(Constants.progressMaxWidth * value, Constants.progressMaxWidth)
  }

  private enum Constants {
    static let progressCornerRadius: CGFloat = 4
    static let progressMaxWidth: CGFloat = 96
  }
}

// MARK: - TrailingItem

struct TrailingItem: View {
  enum Types {
    case icon
    case none
    case text(String)
  }

  var type: Types
  var body: some View {
    switch type {
    case .icon:
      HStack(spacing: 0) {
        Button {} label: {
          SSImage.commonSearch
            .padding(Constants.imagePadding)
        }
        .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)

        Button {} label: {
          SSImage.commonSearch
            .padding(Constants.imagePadding)
        }
        .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)
      }
      .frame(alignment: .trailing)
    case .none:
      EmptyView()
    case let .text(text):
      Button {} label: {
        Text(text)
          .modifier(SSTypoModifier(.title_xxs))
          .padding(Constants.imagePadding)
      }
      .frame(alignment: .trailing)
    }
  }

  private enum Constants {
    static let buttonWidthAndHeight: CGFloat = 44
    static let imagePadding: CGFloat = 10
  }
}
