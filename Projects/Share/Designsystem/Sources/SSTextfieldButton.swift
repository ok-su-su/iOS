//
//  SSTextfieldButton.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSTextFieldButtonConstans

enum SSTextFieldButtonConstans {
  static let cornerRadius: CGFloat = 4
}

// MARK: - SSTextFieldButton

public struct SSTextFieldButton: View {
  let onTap: (() -> Void)?
  let onTapCloseButton: (() -> Void)?
  let onTapSaveButton: (() -> Void)?
  let property: SSTextFieldButtonProperty
  public init(
    _ property: SSTextFieldButtonProperty,
    onTap: (() -> Void)? = nil,
    onTapCloseButton: (() -> Void)? = nil,
    onTapSaveButton: (() -> Void)? = nil
  ) {
    self.property = property
    self.onTapCloseButton = onTapCloseButton
    self.onTapSaveButton = onTapSaveButton
    self.onTap = onTap
  }

  public var body: some View {
    Button {
      if let onTap {
        onTap()
      }
    } label: {
      HStack(spacing: 6) {
        TextField(
          "",
          text: property.$textFieldText,
          prompt: Text(property.prompt)
            .modifier(SSTypoModifier(property.font)) as? Text
        )
        .multilineTextAlignment(.center)
        .modifier(SSTypoModifier(property.font))
        .foregroundStyle(property.textColor)
        .background(.clear)
        .frame(maxWidth: .infinity, alignment: .center)
        .disabled(property.disableTextField)

        if property.isEditingMode {
          if property.showDeleteButton {
            Button {
              if let onTapCloseButton {
                onTapCloseButton()
              }
            } label: {
              SSImage.commonClose
            }
          }

          if property.showCloseButton {
            Button {
              if let onTapSaveButton {
                onTapSaveButton()
              }
            } label: {
              Text(property.buttonText)
                .modifier(property.buttonTextModifierProperty)
                .foregroundStyle(SSColor.gray10)
                .padding(.vertical, property.buttonVerticalSpacing)
                .padding(.horizontal, property.buttonHorizontalSpacing)
            }
            .background(property.buttonBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
          }
        } else {
          if property.showCloseButton {
            Button {
              if let onTapSaveButton {
                onTapSaveButton()
              }
            } label: {
              Text(property.buttonText)
                .modifier(property.buttonTextModifierProperty)
                .foregroundStyle(SSColor.gray10)
                .padding(.vertical, property.buttonVerticalSpacing)
                .padding(.horizontal, property.buttonHorizontalSpacing)
            }
            .background(property.buttonBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
          }

          if property.showDeleteButton {
            Button {
              if let onTapCloseButton {
                onTapCloseButton()
              }
            } label: {
              SSImage.commonDeleteGray
            }
          }
        }
      }
      .padding(.leading, property.leadingSpacing)
      .padding(.trailing, property.trailingSpacing)
      .padding(.vertical, property.verticalSpacing)
      .frame(
        minWidth: property.frame.minWidth,
        idealWidth: property.frame.idealWidth,
        maxWidth: property.frame.maxWidth,
        minHeight: property.frame.minHeight,
        idealHeight: property.frame.idealHeight,
        maxHeight: property.frame.maxHeight,
        alignment: property.frame.alignment
      )
      .background {
        property.backgroundColor
      }
      .clipShape(RoundedRectangle(cornerRadius: SSTextFieldButtonConstans.cornerRadius))
    }
  }
}
