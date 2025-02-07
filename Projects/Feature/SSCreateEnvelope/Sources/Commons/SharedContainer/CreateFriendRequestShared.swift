//
//  CreateFriendRequestShared.swift
//  Sent
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum CreateFriendRequestShared {
  static func setName(_ val: String) {
    var body = getBody()
    body.name = val
    setBody(body)
  }

  static func getName() -> String? {
    getBody().name
  }

  static func setRelation(id: Int) {
    var body = getBody()
    body.relationshipId = id
    setBody(body)
  }

  static func setCustomRelation(name: String) {
    var body = getBody()
    body.customRelation = name
    setBody(body)
  }

  static func setContacts(_ val: String) {
    var body = getBody()
    body.phoneNumber = val
    setBody(body)
  }

  static func reset() {
    setBody(.init())
  }

  static func getBody() -> CreateFriendRequestBody {
    return SharedContainer.getValue(CreateFriendRequestBody.self) ?? .init()
  }

  static func setFriendID(_ id: Int64) {
    var body = getBody()
    body.friendID = id
    setBody(body)
  }

  static func setBody(_ val: CreateFriendRequestBody) {
    SharedContainer.setValue(val)
  }
}
