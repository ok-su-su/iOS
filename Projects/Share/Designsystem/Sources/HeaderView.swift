//
//  HeaderView.swift
//  Designsystem
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - HeaderViewProperty

public struct HeaderViewProperty {
  let title: String
  let type: HeaderViewPropertyType
  
  public enum HeaderViewPropertyType {
    case defaultType
    case depth2Icon
    case depth2Default
    case depthProgressBar(Double)
    case depth2Text(String)
  }

  public init(title: String = "", type: HeaderViewPropertyType) {
    self.title = title
    self.type = type
  }

  var isLogoImage: Bool {
    if case .defaultType = type {
      return true
    }
    return false
  }
  
  var centerItem: CenterItem {
    return switch type {
    case let .depthProgressBar(double):
        .init(type: .progress(double))
    default :
        .init(type: .text(title))
  }
}

// MARK: - LeftHeaderButton

struct LeftItem: View {
  var isImage: Bool
  var body: some View {
    if isImage {
      Image(.commonLogo)
        .resizable()
        .scaledToFit()
    } else {
      Button {} label: {
        Image(.commonArrow)
      }
    }
  }
}

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
      ZStack(alignment: .top) {
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
    return max(Constants.progressMaxWidth * value, Constants.progressMaxWidth)
  }
  private enum Constants {
    static let progressCornerRadius: CGFloat = 4
    static let progressMaxWidth: CGFloat = 96
  }
}

// MARK: - HeaderView

public struct HeaderView: View {
  var property: HeaderViewProperty
  public var body: some View {
    VStack {
      ZStack {
        property.centerItem

        HStack {
          LeftItem(isImage: property.isLogoImage)
            .frame(width: 56, height: 24, alignment: .leading)
            .padding(.leading, Constants.headerLeftMargin)

          Spacer()

          HStack(spacing: 0) {
            Button {} label: {
              Image(uiImage: SSImage.commonSearch)
                .padding(Constants.imagePadding)
            }
            .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)

            Button {} label: {
              Image(uiImage: SSImage.commonSearch)
                .padding(Constants.imagePadding)
            }
            .frame(width: Constants.buttonWidthAndHeight, height: Constants.buttonWidthAndHeight)
          }
          .frame(alignment: .trailing)
        }
        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
      }

      Spacer()
    }
  }

  public init(property: HeaderViewProperty) {
    self.property = property
  }

  private enum Constants {
    static let headerViewWidth: CGFloat = 56
    static let headerViewHeight: CGFloat = 24

    static let buttonWidthAndHeight: CGFloat = 44

    static let imagePadding: CGFloat = 10

    static let headerLeftMargin: CGFloat = 10
  }
}
