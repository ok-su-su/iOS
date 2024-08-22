//
//  CreateAndUpdateEnvelopeResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CreateAndUpdateEnvelopeResponse: Decodable {
  public let envelope: EnvelopeModel
  public let friend: FriendModel
  public let friendRelationship: FriendRelationshipModel
  public let relationship: RelationshipModel
}
