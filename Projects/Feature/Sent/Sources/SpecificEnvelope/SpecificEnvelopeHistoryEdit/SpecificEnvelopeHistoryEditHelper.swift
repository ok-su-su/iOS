//
//  SpecificEnvelopeHistoryEditHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SpecificEnvelopeHistoryEditHelper: Equatable {
  var envelopeDetailProperty: EnvelopeDetailProperty

  var selectedEventName: String
  var selectedRelationName: String
  var editedName: String
  var editedDate: Date
  var editedIsVisited: Bool
  var editedGift: String?
  var editedContacts: String?
  var editedMemo: String?
  init(envelopeDetailProperty: EnvelopeDetailProperty) {
    self.envelopeDetailProperty = envelopeDetailProperty

    selectedEventName = envelopeDetailProperty.eventName
    selectedRelationName = envelopeDetailProperty.relation
    editedName = envelopeDetailProperty.name
    editedDate = envelopeDetailProperty.date
    editedIsVisited = envelopeDetailProperty.isVisited
    editedGift = envelopeDetailProperty.gift
    editedContacts = envelopeDetailProperty.contacts
    editedMemo = envelopeDetailProperty.memo
  }

  var defaultsEventNames: [String] = [
    "결혼식",
    "돌잔치",
    "장례식",
    "생일기념일",
  ]

  var defaultsRelationNames: [String] = [
    "친구",
    "가족",
    "친척",
    "동료",
  ]
}
