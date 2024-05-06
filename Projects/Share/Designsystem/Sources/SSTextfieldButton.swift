//
//  SSButton.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSButtonConstans

enum SSTextFieldButtonConstans {
  static let cornerRadius: CGFloat = 4
}

// MARK: - SSButton

public struct SSTextFieldButton: View {
  let onTapCloseButton: (() -> Void)?
  let onTapSaveButton: (() -> Void)?
  let property: SSTextFieldButtonProperty
  public init(
    _ property: SSTextFieldButtonProperty,
    onTapCloseButton: (() -> Void)?,
    onTapSaveButton: (() -> Void)?
  ) {
    self.property = property
    self.onTapCloseButton = onTapCloseButton
    self.onTapSaveButton = onTapSaveButton
  }

  public var body: some View {
    HStack(spacing: 6) {

      TextField("", text: property.$textFieldText, prompt: Text(property.prompt))
        .background(.clear)
        .foregroundStyle(property.textColor)
        .frame(maxWidth: .infinity)
      
      if property.showCloseButton{
        Button {
          if let onTapCloseButton {
            onTapCloseButton()
          }
        } label: {
          SSImage.commonClose
        }
      }
    
      
      Button {
        if let onTapSaveButton {
          onTapSaveButton()
        }
      } label: {
        Text("저장")
          .modifier(property.saveButtonTextModifierProperty)
          .foregroundStyle(SSColor.gray10)
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
    .disabled(property.isDisable)
  }
}
