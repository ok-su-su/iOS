//
//  RegisterFont.swift
//  Designsystem
//
//  Created by MaraMincho on 4/11/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - R

private final class R {}

public extension Font {
  /// 전역적으로 PretnedardFont를 사용할 수 있게 해줍니다.
  ///
  /// 앱 처음 시작시 불리면 전역적으로 pretendard-regular를 사용할 수 있게 됩니다.
  static func registerFont() {
    let fontName = ["Pretendard-Regular", "Pretendard-Bold"]
    let urls = fontName.compactMap { Bundle(for: R.self).url(forResource: $0, withExtension: "otf") }
    urls.forEach { CTFontManagerRegisterFontsForURL($0 as CFURL, .process, nil) }
  }
}
