//
//  SpecificEnvelopeEditHelper.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSRegexManager

// MARK: - SpecificEnvelopeEditHelper

public struct SpecificEnvelopeEditHelper: Equatable, Sendable {
  var envelopeType: SpecificEnvelopeType {
    let typeString = envelopeDetailProperty.envelope.type
    switch typeString {
    case "SENT":
      return .sent
    case "RECEIVED":
      return .received
    default:
      return .sent
    }
  }

  var envelopeEditProperties: [EnvelopeEditPropertiable] {
    [
      priceProperty,
      eventSectionButtonHelper,
      relationSectionButtonHelper,
      nameEditProperty,
      dateEditProperty,
      visitedSectionButtonHelper,
      giftEditProperty,
      contactEditProperty,
      memoEditProperty,
    ]
  }

  var envelopeDetailProperty: EnvelopeDetailProperty

  var priceProperty: PriceEditProperty

  var eventSectionButtonHelper: SingleSelectButtonHelper<CreateEnvelopeEventProperty>
  var eventSectionButtonCustomItem: CreateEnvelopeEventProperty

  var relationSectionButtonHelper: SingleSelectButtonHelper<CreateEnvelopeRelationItemProperty>
  var relationSectionButtonCustomItem: CreateEnvelopeRelationItemProperty

  var nameEditProperty: NameEditProperty

  var dateEditProperty: DateEditProperty

  var visitedSectionButtonHelper: SingleSelectButtonHelper<VisitedSelectButtonItem>
  var visitedEditProperty: VisitedEditProperty

  var giftEditProperty: GiftEditProperty

  var contactEditProperty: ContactEditProperty

  var memoEditProperty: MemoEditProperty

  init(
    envelopeDetailProperty: EnvelopeDetailProperty,
    eventItems: [CreateEnvelopeEventProperty],
    customEventItem: CreateEnvelopeEventProperty,
    relationItems: [CreateEnvelopeRelationItemProperty],
    customRelationItem: CreateEnvelopeRelationItemProperty
  ) {
    self.envelopeDetailProperty = envelopeDetailProperty
    // Price 관련
    priceProperty = .init(price: envelopeDetailProperty.envelope.amount)

    // 만약 현재 이벤트에 default 이벤트에 존재 하지 않는다면
    eventSectionButtonCustomItem = customEventItem
    eventSectionButtonCustomItem.name = envelopeDetailProperty.category.customCategory ?? ""
    eventSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.eventNameTitle,
      items: eventItems,
      isCustomItem: eventSectionButtonCustomItem,
      initialSelectedID: envelopeDetailProperty.category.id,
      customTextFieldPrompt: "경조사 이름"
    )

    // 만약 현재 관계가 default 이벤트에 존재 하지 않는다면
    relationSectionButtonCustomItem = customRelationItem
    relationSectionButtonCustomItem.relation = envelopeDetailProperty.friendRelationship.customRelation ?? ""
    relationSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.relationTitle,
      items: relationItems,
      isCustomItem: relationSectionButtonCustomItem,
      initialSelectedID: envelopeDetailProperty.relationship.id,
      customTextFieldPrompt: "관계 이름"
    )

    nameEditProperty = .init(textFieldText: envelopeDetailProperty.friend.name)
    let date = CustomDateFormatter.getDate(from: envelopeDetailProperty.envelope.handedOverAt) ?? .now
    dateEditProperty = .init(date: date)

    // has visited?
    visitedSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.visitedTitle,
      items: VisitedSelectButtonItem.defaultItems(),
      isCustomItem: nil,
      initialSelectedID: envelopeDetailProperty.hasVisitedID,
      customTextFieldPrompt: nil,
      isEssentialProperty: false
    )

    // Additional Property initialize
    visitedEditProperty = .init(isVisited: envelopeDetailProperty.envelope.hasVisited)
    giftEditProperty = .init(gift: envelopeDetailProperty.envelope.gift)
    contactEditProperty = .init(contact: envelopeDetailProperty.friend.phoneNumber)
    memoEditProperty = .init(memo: envelopeDetailProperty.envelope.memo)
  }

  mutating func changeName(_ name: String) {
    nameEditProperty.textFieldText = name
  }

  func isValidName() -> Bool {
    nameEditProperty.isValid
  }

  func isShowToastByName() -> Bool {
    nameEditProperty.isShowToast
  }

  mutating func changeGift(_ name: String) {
    giftEditProperty.gift = name
  }

  func isValidGift() -> Bool {
    giftEditProperty.isValid
  }

  func isShowToastByGift() -> Bool {
    giftEditProperty.isShowToast
  }

  mutating func changeContact(_ name: String) {
    contactEditProperty.contact = name
  }

  func isValidContact() -> Bool {
    contactEditProperty.isValid
  }

  func isShowToastByContact() -> Bool {
    contactEditProperty.isShowToast
  }

  mutating func changeMemo(_ name: String) {
    memoEditProperty.memo = name
  }

  func isShowToastByMemo() -> Bool {
    memoEditProperty.isShowToast
  }

  func isValidMemo() -> Bool {
    memoEditProperty.isValid
  }

  mutating func changePrice(_ value: String) {
    priceProperty.setPriceTextFieldText(value)
  }

  func isValidPrice() -> Bool {
    priceProperty.isValid
  }

  func isShowToastByPrice() -> Bool {
    priceProperty.isShowToast
  }

  func isChangedProperty() -> Bool {
    false
  }

  func isValidToSave() -> Bool {
    let isChanged = !envelopeEditProperties.filter(\.isChanged).isEmpty
    print(eventSectionButtonHelper)
    let isValid = envelopeEditProperties.filter { $0.isValid == false }.isEmpty
    return isValid && isChanged
  }
}

private extension EnvelopeDetailProperty {
  var hasVisitedID: VisitedSelectButtonItem.ID? {
    guard let hasVisited = envelope.hasVisited else {
      return nil
    }
    return hasVisited ? VisitedSelectButtonItem.yes.id : VisitedSelectButtonItem.no.id
  }
}

// MARK: - SingleSelectButtonHelper + EnvelopeEditPropertiable

extension SingleSelectButtonHelper: EnvelopeEditPropertiable {
  var isValid: Bool {
    isValid()
  }

  var isChanged: Bool {
    // 커스텀 아이템이 되었고, 과거에 커스텀 아이템 타이틀이 존재했다면
    if let initialCustomTitle = initialSelectedCustomTitle, isCustomItemSelected {
      return initialCustomTitle != selectedItem?.title
    }
    // 커스텀 아이템이 존재하지 않았다면 선택되지 않았다면
    return initialSelectedID != selectedItem?.id
  }
}
