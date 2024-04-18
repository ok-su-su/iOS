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

  var leadingItem: LeadingItem {
    return switch type {
    case .defaultType:
      LeadingItem(isImage: true)
    default:
      LeadingItem(isImage: false)
    }
  }

  var centerItem: CenterItem {
    return switch type {
    case let .depthProgressBar(double):
      .init(type: .progress(double))
    default:
      .init(type: .text(title))
    }
  }

  var trailingItem: TrailingItem {
    return switch type {
    case .defaultType,
         .depth2Icon
         :
      TrailingItem(type: .icon)
    case .depth2Default,
         .depthProgressBar:
      TrailingItem(type: .none)
    case let .depth2Text(text):
      TrailingItem(type: .text(text))
    }
  }
}

// MARK: - HeaderView

public struct HeaderView: View {
  var property: HeaderViewProperty
  public var body: some View {
    VStack {
      ZStack {
        property
          .centerItem

        HStack {
          property
            .leadingItem

          Spacer()

          property
            .trailingItem
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
  }
}
