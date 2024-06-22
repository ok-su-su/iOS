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

  static func setPhoneNumber(_: String) {}

  private static func getBody() -> CreateFriendRequestBody {
    return SharedContainer.getValue(CreateFriendRequestBody.self) ?? .init()
  }

  private static func setBody(_ val: CreateFriendRequestBody) {
    SharedContainer.setValue(val)
  }
}
