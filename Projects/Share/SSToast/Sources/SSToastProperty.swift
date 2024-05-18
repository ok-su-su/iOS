//
//  SSToastProperty.swift
//  SSToast
//
//  Created by MaraMincho on 5/18/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct SSToastProperty: Equatable {
  var toastMessage: String
  var type: TrailingType
  var duration: Double
  
  public enum TrailingType: Equatable {
    case none
    case text(String)
    case refresh
  }
  
  /// ToastMessage에 필요한 Type을 정의합니다.
  /// - Parameters:
  ///   - toastMessage: Toast에 표시할 메시지입니다.
  ///   - type: Toast 오른쪽에 나타날 버튼에 대한 타입을 상정합니다.
  ///   - duration: Toast지속시간을 나타냅니다.
  public init(toastMessage: String, trailingType type: TrailingType, duration: Double) {
    self.toastMessage = toastMessage
    self.type = type
    self.duration = duration
  }
}
