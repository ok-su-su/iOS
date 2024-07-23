//
//  CreateAndUpdateEnvelopeResponse.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct CreateAndUpdateEnvelopeResponse: Decodable {
  let envelope: EnvelopeModel
  let friend: FriendModel
  let friendRelationship: FriendRelationshipModel
  let relationship: RelationshipModel
}
