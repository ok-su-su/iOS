//
//  SSButtonWithState.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSButtonWithState

public struct SSButtonWithState: View {
  let onTap: () -> Void
  @ObservedObject var property: SSButtonPropertyState
  public init(_ property: SSButtonPropertyState, onTap: @escaping () -> Void) {
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
        minHeight: property.frame.minHeight,
        idealHeight: property.frame.idealHeight,
        maxHeight: property.size.height,
        alignment: property.frame.alignment
      )
      .background {
        property.backgroundColor
      }
      .clipShape(RoundedRectangle(cornerRadius: SSButtonConstans.cornerRadius))
      .modifier(LinedModifier(lineColor: property.lineColor))
    }
    .disabled(property.isDisable)
  }
}
