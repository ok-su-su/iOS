//
//  SSText.swift
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
      .lineSpacing(designSystemFont.lineHeight)
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

public struct SSTypoModifier: ViewModifier {
  private let designSystemFont: SSFont
  public init(_ designSystemFont: SSFont) {
    self.designSystemFont = designSystemFont
  }

  @ViewBuilder
  public func body(content: Content) -> some View {
    content
      .font(designSystemFont.font)
      .tracking(ssLetterSpacing)
      .lineSpacing(designSystemFont.lineHeight)
  }
}


