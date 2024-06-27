//
//  SpecificEnvelopeSharedState.swift
//  Sent
//
//  Created by MaraMincho on 6/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class SpecificEnvelopeSharedState {
  private init() {}

  static let shared = SpecificEnvelopeSharedState()

  /// 한번 읽은 정보는 사라집니다.
  func getDeletedEnvelopeID() -> Int64? {
    let id = deletedID
    deletedID = nil
    return id
  }

  func setDeleteEnvelopeID(_ id: Int64) {
    deletedID = id
  }

  private var deletedID: Int64?
}
