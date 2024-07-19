//
//  SSButton.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSButtonConstans

enum SSButtonConstans {
  static let cornerRadius: CGFloat = 4
}

// MARK: - SSButton

public struct SSButton: View {
  let onTap: () -> Void
  let property: SSButtonProperty
  public init(_ property: SSButtonProperty, onTap: @escaping () -> Void) {
    self.property = property
    self.onTap = onTap
  }

  public var body: some View {
    Button {
      onTap()
    } label: {
      HStack(spacing: 6) {
        switch property.leftIcon {
        case .none:
          EmptyView()
        case let .icon(image):
          image
        }

        Text(property.buttonText)
          .modifier(SSTypoModifier(property.font))
          .foregroundStyle(property.textColor)

        switch property.rightIcon {
        case .none:
          EmptyView()
        case let .icon(image):
          image
        }
      }
      .padding(.horizontal, property.size.horizontalSpacing)
      .padding(.vertical, property.size.verticalSpacing)
      .frame(
        minWidth: property.frame.minWidth,
        idealWidth: property.frame.idealWidth,
        maxWidth: property.frame.maxWidth,
        minHeight: property.size.height,
        idealHeight: property.frame.idealHeight,
        maxHeight: property.frame.maxHeight,
        alignment: property.frame.alignment
      )
      .background {
        property.backgroundColor
      }
      .clipShape(RoundedRectangle(cornerRadius: SSButtonConstans.cornerRadius))
      .modifier(LinedModifier(lineColor: property.lineColor))
    }
    .frame(height: property.size.height)
    .disabled(property.isDisable)
  }
}

// MARK: - LinedModifier

struct LinedModifier: ViewModifier {
  var lineColor: Color?

  @ViewBuilder
  func body(content: Content) -> some View {
    if let lineColor {
      content.overlay {
        RoundedRectangle(cornerRadius: 4)
          .inset(by: 0.5)
          .stroke(lineColor, lineWidth: 1)
      }
    } else {
      content
    }
  }
}
