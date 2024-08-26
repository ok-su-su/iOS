//
//  SSTypoModifier.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSText

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
  }
}

// MARK: - FontWithLineHeight

struct FontWithLineHeight: ViewModifier {
  let font: UIFont
  let lineHeight: CGFloat

  func body(content: Content) -> some View {
    content
      .font(Font(font))
      .lineSpacing(lineHeight - font.lineHeight)
      .padding(.vertical, (lineHeight - font.lineHeight) / 2)
  }
}

// MARK: - SSTextModifier

public struct SSTextModifier: ViewModifier {
  private let designSystemFont: SSFont
  private let isBold: Bool

  @available(*, deprecated, renamed: "SSTypoModifier", message: "SSTextModifier는 SSFont에 Text가 추가됨에 따라, isBold 가 init에서 삭제된 SSTypoModifier를 를 이용해주세요")
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

// MARK: - SSTypoModifier

public struct SSTypoModifier: ViewModifier {
  private let designSystemFont: SSFont
  public init(_ designSystemFont: SSFont) {
    self.designSystemFont = designSystemFont
  }

  @ViewBuilder
  public func body(content: Content) -> some View {
    let lineSpacing = designSystemFont.lineHeight - designSystemFont.sizeTypes.fontSize
    let linePadding = lineSpacing / 2
    content
      .font(designSystemFont.font)
      .tracking(ssLetterSpacing)
      .padding(.vertical, linePadding)
      .lineSpacing(lineSpacing)
  }
}

public extension View {
  func applySSFont(_ designSystemFont: SSFont) -> some View {
    modifier(SSTypoModifier(designSystemFont))
  }
}

public extension Text {
  func applySSFontToText(_ designSystemFont: SSFont) -> Text {
    font(.custom(designSystemFont))
  }
}
