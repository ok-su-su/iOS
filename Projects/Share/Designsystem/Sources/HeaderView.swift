//
//  HeaderView.swift
//  Designsystem
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI


public struct HeaderViewProperty {
  var title: String
  var type: HeaderViewPropertyType
  public enum HeaderViewPropertyType {
    case defaultType
    case depth2Icon
    case depth2Default
    case depthProgressBar(Double)
    case depth2Text(String)
  }
  public init(title: String, type: HeaderViewPropertyType) {
    self.title = title
    self.type = type
  }
}
public struct HeaderView: View {
  var property: HeaderViewProperty
  public var body: some View {
    VStack {
      ZStack {
        Text("타이틀")
          .modifier(SSTypoModifier(.title_xs))
          .frame(maxWidth: .infinity, alignment: .center)

        HStack {
          Image(.commonLogo)
            .resizable()
            .scaledToFit()
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
