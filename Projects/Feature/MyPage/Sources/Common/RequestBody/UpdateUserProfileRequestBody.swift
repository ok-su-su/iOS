//
//  UpdateUserProfileRequestBody.swift
//  MyPage
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

// MARK: - UpdateUserProfileRequestBody

struct UpdateUserProfileRequestBody: Encodable {
  let name: String
  /// 성별 M: 남자, W 여자
  let gender: String?
  /// 출생 년도
  let birth: Int?

  func getBody() -> Data {
    do {
      return try JSONEncoder().encode(self)
    } catch {
      os_log("UpdateUserProfileRequestBody Encode 실패했습니다.")
      return Data()
    }
  }
}
