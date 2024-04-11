//
//  DesignSystemText.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - DesignSystemText

public struct DesignSystemText: View {
  var text: String
  var designSystemFont: DesignSystemFont

  public init(text: String, designSystemFont: DesignSystemFont) {
    self.text = text
    self.designSystemFont = designSystemFont
  }

  public var body: some View {
    Text(text)
      .font(designSystemFont.font)
      .tracking(-0.03)
  }
}
