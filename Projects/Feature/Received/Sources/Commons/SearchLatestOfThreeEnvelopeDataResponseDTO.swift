//
//  SearchLatestOfThreeEnvelopeDataResponseDTO.swift
//  Received
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchLatestOfThreeEnvelopeDataResponseDTO

struct SearchLatestOfThreeEnvelopeDataResponseDTO: Decodable {
  let envelope: EnvelopeModel
  let category: CategoryWithCustomModel?
  let relationship: RelationshipModel?
  let friend: FriendModel?
  let friendRelationship: FriendRelationshipModel?
}
