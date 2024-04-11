//
//  DesignSystemFont.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - DesignSystemFont

public enum DesignSystemFont {
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
