//
//  SSText.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - DesignSystemText

public struct SSText: View {
  var text: String
  var designSystemFont: SSFont

  public init(text: String, designSystemFont: SSFont) {
    self.text = text
    self.designSystemFont = designSystemFont
  }

  public var body: some View {
    Text(text)
      .font(designSystemFont.font)
      .tracking(ssLetterSpacing)
      .lineSpacing(designSystemFont.lineHeight)
  }
}

// MARK: - SSTextModifier

public struct SSTextModifier: ViewModifier {
  private let designSystemFont: SSFont
  private let isBold: Bool
  public init(_ designSystemFont: SSFont, isBold: Bool = false) {
    self.designSystemFont = designSystemFont
    self.isBold = isBold
  }

  @ViewBuilder
  public func body(content: Content) -> some View {
    content
      .font(designSystemFont.font)
      .bold(isBold)
      .tracking(ssLetterSpacing)
      .lineSpacing(designSystemFont.lineHeight)
  }
}
