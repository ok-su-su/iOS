//
//  Badges.swift
//  susu
//
//  Created by MaraMincho on 4/15/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

public struct SmallBadgeProperty {
  let badgeString: String
  let badgeColor: BadgeColor
  let size: BadgeSize
  
  public init(size: BadgeSize, badgeString: String, badgeColor: BadgeColor) {
    self.size = size
    self.badgeString = badgeString
    self.badgeColor = badgeColor
  }
  public enum BadgeColor {
    case gray20
    case orange60
    case blue60
    case gray90
    case gray40
    case gray30
    case red60
  }
  
  public enum BadgeSize {
    case small
    case xSmall
  }
  var horizontalPaddingValue: CGFloat {
    return switch size {
    default:
      8
    }
  }
  var verticalPaddingValue: CGFloat {
    switch size {
    case .small:
      return 2
    case .xSmall:
      return 0
    }
  }
  
  var textColor: Color {
    return switch badgeColor {
    case .gray20:
      SSColor.gray70
    case .orange60:
      SSColor.gray10
    case .blue60:
      SSColor.gray20
    case .gray90:
      SSColor.gray10
    case .gray40:
      SSColor.gray10
    case .gray30:
      SSColor.gray70
    case .red60:
      SSColor.gray20
    }
  }
  
  var backgroundColor: Color {
    return switch badgeColor {
    case .gray20:
      SSColor.gray20
    case .orange60:
      SSColor.orange60
    case .blue60:
      SSColor.blue60
    case .gray90:
      SSColor.gray90
    case .gray40:
      SSColor.gray40
    case .gray30:
      SSColor.gray30
    case .red60:
      SSColor.red60
    }
  }
  
}

public struct SmallBadge: View {
  let property: SmallBadgeProperty
  public init(property: SmallBadgeProperty) {
    self.property = property
  }
  public var body: some View {
    VStack{
      Text(property.badgeString)
        .modifier(SSTextModifier(.title_xxxs))
        .foregroundStyle(property.textColor)
    }
    .padding(.vertical, property.verticalPaddingValue)
    .padding(.horizontal, property.horizontalPaddingValue)
    .background{
      property.backgroundColor
    }
    .cornerRadius(4)
  }
}

#Preview {
  VStack {
    Spacer()
    HStack {
      SmallBadge(property: .init(size: .small, badgeString: "10000원", badgeColor: .gray20))
      SmallBadge(property: .init(size: .small, badgeString: "가족", badgeColor: .orange60))
      SmallBadge(property: .init(size: .small, badgeString: "미방문", badgeColor: .blue60))
      SmallBadge(property: .init(size: .small, badgeString: "선물이", badgeColor: .gray90))
    }
    HStack {
      SmallBadge(property: .init(size: .small, badgeString: "선물이", badgeColor: .gray40))
      SmallBadge(property: .init(size: .small, badgeString: "10000원", badgeColor: .gray30))
      SmallBadge(property: .init(size: .small, badgeString: "미방문", badgeColor: .red60))
    }
    Spacer()
    HStack {
      SmallBadge(property: .init(size: .xSmall, badgeString: "10000원", badgeColor: .gray20))
      SmallBadge(property: .init(size: .xSmall, badgeString: "가족", badgeColor: .orange60))
      SmallBadge(property: .init(size: .xSmall, badgeString: "미방문", badgeColor: .blue60))

    }.padding(.bottom, 10)
    HStack {
      SmallBadge(property: .init(size: .xSmall, badgeString: "선물이", badgeColor: .gray90))
      SmallBadge(property: .init(size: .xSmall, badgeString: "선물이", badgeColor: .gray40))
      SmallBadge(property: .init(size: .xSmall, badgeString: "10000원", badgeColor: .gray30))
      SmallBadge(property: .init(size: .xSmall, badgeString: "미방문", badgeColor: .red60))
    }
    Spacer()
    Spacer()
  }

}
