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
    return switch self {
    case .title_xxxxl:
      .custom("Pretendard-Regular", size: 40)
    case .title_xxxl:
      .custom("Pretendard-Regular", size: 36)
    case .title_xxl:
      .custom("Pretendard-Regular", size: 32)
    case .title_xl:
      .custom("Pretendard-Regular", size: 28)
    case .title_l:
      .custom("Pretendard-Regular", size: 24)
    case .title_m:
      .custom("Pretendard-Regular", size: 20)
    case .title_s:
      .custom("Pretendard-Regular", size: 18)
    case .title_xs:
      .custom("Pretendard-Regular", size: 16)
    case .title_xxs:
      .custom("Pretendard-Regular", size: 14)
    case .title_xxxs:
      .custom("Pretendard-Regular", size: 12)
    case .title_xxxxs:
      .custom("Pretendard-Regular", size: 10)
    }
  }
}

// MARK: - R

private final class R {}

public extension Font {
  /// 전역적으로 PretnedardFont를 사용할 수 있게 해줍니다.
  ///
  /// 앱 처음 시작시 불리면 전역적으로 pretendard-regular를 사용할 수 있게 됩니다.
  static func registerFont() {
    guard let url = Bundle(for: R.self).url(forResource: "Pretendard-Regular", withExtension: "otf"),
          CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    else { return }
  }
}
