//
//  SSBadges.swift
//  susu
//
//  Created by MaraMincho on 4/15/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SmallBadgeProperty

public struct SmallBadgeProperty {
  let badgeString: String
  let badgeColor: BadgeColor
  let size: BadgeSize

  public init(size: BadgeSize, badgeString: String, badgeColor: BadgeColor) {
    self.size = size
    self.badgeString = badgeString
    self.badgeColor = badgeColor
  }

  var badgeHeight: CGFloat {
    switch size {
    case .small:
      24
    case .xSmall:
      20
    }
  }

  public enum BadgeColor: String {
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

// MARK: - SmallBadge

public struct SmallBadge: View {
  let property: SmallBadgeProperty
  public init(property: SmallBadgeProperty) {
    self.property = property
  }

  public var body: some View {
    VStack {
      Text(property.badgeString)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(property.textColor)
    }
    .padding(.vertical, property.verticalPaddingValue)
    .padding(.horizontal, property.horizontalPaddingValue)
    .background {
      property.backgroundColor
    }
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}
