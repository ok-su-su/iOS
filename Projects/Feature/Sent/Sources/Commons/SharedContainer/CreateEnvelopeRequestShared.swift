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
    body.category = .init(id: id)
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
    body.category = .init(customCategory: name)
    setBody(body)
  }

  static func setDate(_ date: Date) {
    os_log("CreateEnvelopeRequest의 Date을 저장합니다.\nEventName = \(date.description)")
    var body = getBody()
    body.handedOverAt = date.ISO8601Format()
    setBody(body)
  }

  static func setIsVisited(_ val: Bool) {
    os_log("CreateEnvelopeRequest의 방문 여부를 저장합니다.\nEventName = \(val)")
    var body = getBody()
    body.hasVisited = val
    setBody(body)
  }

  static func setMemo(_ val: String) {
    os_log("CreateEnvelopeRequest의 메모 저장합니다.\nMemo = \(val)")
    var body = getBody()
    body.memo = val
    setBody(body)
  }

  static func setGift(_ val: String) {
    os_log("CreateEnvelopeRequest의 선물을 저장합니다.\nGift = \(val)")
    var body = getBody()
    body.gift = val
    setBody(body)
  }

  static func reset() {
    setBody(.init(type: "SENT"))
  }

  static func resetAdditional() {
    var body = getBody()
    body.gift = nil
    body.hasVisited = nil
    body.memo = nil
    setBody(body)
  }

  static func printBody() {
    print(getBody())
  }

  private static func getBody() -> CreateEnvelopeRequestBody {
    SharedContainer.getValue(CreateEnvelopeRequestBody.self) ?? .init(type: "SENT")
  }

  private static func setBody(_ val: CreateEnvelopeRequestBody) {
    SharedContainer.setValue(val)
  }
}
