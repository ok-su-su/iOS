//
//  SSFont.swift
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

// MARK: - SSFont

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

  case text_xxxxl
  case text_xxxl
  case text_xxl
  case text_xl
  case text_l
  case text_m
  case text_s
  case text_xs
  case text_xxs
  case text_xxxs
  case text_xxxxs

  var sizeTypes: SizeTypes {
    return switch self {
    case .text_xxxxl,
         .title_xxxxl
         :
      .xxxxl
    case .text_xxxl,
         .title_xxxl
         :
      .xxxl
    case .text_xxl,
         .title_xxl:
      .xxl
    case .text_xl,
         .title_xl:
      .xl
    case .text_l,
         .title_l:
      .l
    case .text_m,
         .title_m:
      .m
    case .text_s,
         .title_s:
      .s
    case .text_xs,
         .title_xs:
      .xs
    case .text_xxs,
         .title_xxs:
      .xxs
    case .text_xxxs,
         .title_xxxs:
      .xxxs
    case .text_xxxxs,
         .title_xxxxs:
      .xxxxs
    }
  }

  var weightType: WeightType {
    return switch self {
    case .title_l,
         .title_m,
         .title_s,
         .title_xl,
         .title_xs,
         .title_xxl,
         .title_xxs,
         .title_xxxl,
         .title_xxxs,
         .title_xxxxl,
         .title_xxxxs:
      .title
    case .text_l,
         .text_m,
         .text_s,
         .text_xl,
         .text_xs,
         .text_xxl,
         .text_xxs,
         .text_xxxl,
         .text_xxxs,
         .text_xxxxl,
         .text_xxxxs:
      .text
    }
  }

  var font: Font {
    return switch weightType {
    case .title:
      .custom("Pretendard-Bold", fixedSize: sizeTypes.fontSize)
    case .text:
      .custom("Pretendard-Regular", fixedSize: sizeTypes.fontSize)
    }
  }

  var lineHeight: CGFloat {
    return sizeTypes.lineHeight
  }
}

// MARK: - SizeTypes

enum SizeTypes {
  case xxxxl
  case xxxl
  case xxl
  case xl
  case l
  case m
  case s
  case xs
  case xxs
  case xxxs
  case xxxxs

  var fontSize: CGFloat {
    return switch self {
    case .xxxxl:
      40
    case .xxxl:
      36
    case .xxl:
      32
    case .xl:
      28
    case .l:
      24
    case .m:
      20
    case .s:
      18
    case .xs:
      16
    case .xxs:
      14
    case .xxxs:
      12
    case .xxxxs:
      10
    }
  }

  var lineHeight: CGFloat {
    return switch self {
    case .l,
         .xl,
         .xxl,
         .xxxl,
         .xxxxl:
      8
    case .m,
         .s,
         .xs:
      6
    case .xxs:
      5
    case .xxxs:
      4
    case .xxxxs:
      3
    }
  }
}

// MARK: - WeightType

enum WeightType {
  case title
  case text
}
