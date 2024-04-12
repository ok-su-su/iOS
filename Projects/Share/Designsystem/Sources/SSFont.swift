//
//  DesignSystemFont.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

public extension Font {
  /// susu 의 DesignSystem font 를 가져옵니다.
  /// - Parameter font: susu의 DesignSystemFont
  /// - Returns: font
  ///
  /// eg) Text("hello World").font(.custom(.title_l))
  static func custom(_ font: SSFont) -> Self {
    return font.font
  }
}

// MARK: - DesignSystemFont

public enum SSFont {
  case title_xxxxl
  case title_xxxl
  case title_xxl
  case title_xl
  case title_l
  case title_m
  case title_s
  case title_xs
  case title_xxs
  case title_xxxs
  case title_xxxxs

  public var font: Font {
    return .custom("Pretendard-Regular", size: fontSize)
  }

  var lineHeight: CGFloat {
    return switch self {
    case .title_l,
         .title_xl,
         .title_xxl,
         .title_xxxl,
         .title_xxxxl:
      16
    case .title_m,
         .title_s,
         .title_xs:
      12
    case .title_xxs:
      10
    case .title_xxxs:
      8
    case .title_xxxxs:
      6
    }
  }

  var fontSize: CGFloat {
    return switch self {
    case .title_xxxxl:
      40
    case .title_xxxl:
      36
    case .title_xxl:
      32
    case .title_xl:
      28
    case .title_l:
      24
    case .title_m:
      20
    case .title_s:
      18
    case .title_xs:
      15
    case .title_xxs:
      14
    case .title_xxxs:
      16
    case .title_xxxxs:
      10
    }
  }
}
