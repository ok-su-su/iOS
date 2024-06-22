//
//  CreateEnvelopeRequestShared.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

enum CreateEnvelopeRequestShared {
  static func setEvent(id: Int) {
    os_log("CreateEnvelopeRequest의 Event을 저장합니다.\nid = \(id)")
    var body = getBody()
    body.category?.id = id
    setBody(body)
  }

  static func setAmount(_ amount: Int64) {
    os_log("CreateEnvelopeRequest의 Amount을 저장합니다.\namount = \(amount.description)")
    var body = getBody()
    body.amount = amount
    setBody(body)
  }

  static func setCustomEvent(_ name: String) {
    os_log("CreateEnvelopeRequest의 Event을 저장합니다.\nEventName = \(name)")
    var body = getBody()
    body.category?.customCategory = name
    setBody(body)
  }

  static func setDate(_ date: Date) {
    os_log("CreateEnvelopeRequest의 Date을 저장합니다.\nEventName = \(date.description)")
    var body = getBody()
    body.handedOverAt = date.ISO8601Format()
    setBody(body)
  }

  private static func getBody() -> CreateEnvelopeRequestBody {
    SharedContainer.getValue(CreateEnvelopeRequestBody.self) ?? .init(type: "SENT")
  }

  private static func setBody(_ val: CreateEnvelopeRequestBody) {
    SharedContainer.setValue(val)
  }
}
