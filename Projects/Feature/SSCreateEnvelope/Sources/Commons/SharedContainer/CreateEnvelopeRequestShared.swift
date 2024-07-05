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
  static func setFriendID(id: Int64) {
    os_log("CreateEnvelopeRequest의 FriendID을 저장합니다.\nid = \(id)")
    var body = getBody()
    body.friendID = id
    setBody(body)
  }

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
    body.category?.customCategory = name
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

  static func reset(type: CreateType? = nil) {
    guard let type else {
      SharedContainer.deleteValue(CreateEnvelopeRequestBody.self)
      return
    }
    setBody(.init(type: type.key))
  }

  static func resetAdditional() {
    var body = getBody()
    body.gift = nil
    body.hasVisited = nil
    body.memo = nil
    setBody(body)
  }

  static func setCreateType(_ type: CreateType) {
    SharedContainer.setValue(key: String(describing: CreateType.self), type.key)
  }

  static func getCreateType() -> String {
    let typeString: String? = SharedContainer.getValue(key: String(describing: CreateType.self))
    return typeString ?? ""
  }

  static func setLedger(id: Int64) {
    var body = getBody()
    body.ledgerID = id
    setBody(body)
  }

  static func getType() -> String {
    getBody().type
  }

  static func getBody() -> CreateEnvelopeRequestBody {
    guard let cur = SharedContainer.getValue(CreateEnvelopeRequestBody.self) else {
      os_log(.error, "CreateEnvelope Type이 지정되어지지 않았습니다. 심각한 에러입니다.")
      return .init(type: "NONE")
    }
    return cur
  }

  private static func setBody(_ val: CreateEnvelopeRequestBody) {
    SharedContainer.setValue(val)
  }
}
