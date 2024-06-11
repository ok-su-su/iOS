//
//  String+Regex.swift
//  Designsystem
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public extension String {
  /// 한글과 영어를 포함한 1에서 10글자 사이의 정규식 입니다.
  static let SSNameRegexString = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]{1,10}$"
}
