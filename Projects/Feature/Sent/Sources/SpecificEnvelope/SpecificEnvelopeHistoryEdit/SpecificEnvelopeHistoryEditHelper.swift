//
//  SpecificEnvelopeHistoryEditHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SpecificEnvelopeHistoryEditHelper

struct SpecificEnvelopeHistoryEditHelper: Equatable {
  var envelopeDetailProperty: EnvelopeDetailProperty

  var eventSectionButtonHelper: SingleSelectButtonHelper<EventSingeSelectButtonItem>
  var eventSectionButtonCustomItem: EventSingeSelectButtonItem = .init(title: "")
  ///  var selectedEventName: String
  ///  var selectedRelationName: String
  ///  var editedName: String
  ///  var editedDate: Date
  ///  var editedIsVisited: Bool
  ///  var editedGift: String?
  ///  var editedContacts: String?
  ///  var editedMemo: String?
  init(envelopeDetailProperty: EnvelopeDetailProperty) {
    self.envelopeDetailProperty = envelopeDetailProperty
    eventSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.eventName,
      items: EventSingeSelectButtonItem.defaultItems(),
      isCustomItem: eventSectionButtonCustomItem,
      customTextFieldPrompt: "경조사 이름"
    )
//    selectedEventName = envelopeDetailProperty.eventName
//    selectedRelationName = envelopeDetailProperty.relation
//    editedName = envelopeDetailProperty.name
//    editedDate = envelopeDetailProperty.date
//    editedIsVisited = envelopeDetailProperty.isVisited
//    editedGift = envelopeDetailProperty.gift
//    editedContacts = envelopeDetailProperty.contacts
//    editedMemo = envelopeDetailProperty.memo
  }
}

// MARK: - EventSingeSelectButtonItem

struct EventSingeSelectButtonItem: SingleSelectButtonItemable {
  var id: UUID = .init()
  var title: String
  init(title: String) {
    self.title = title
  }
}

extension EventSingeSelectButtonItem {
  static func defaultItems() -> [Self] {
    let defaultsEventNames: [String] = [
      "결혼식",
      "돌잔치",
      "장례식",
      "생일기념일",
    ]
    return defaultsEventNames.map { .init(title: $0) }
  }
}
