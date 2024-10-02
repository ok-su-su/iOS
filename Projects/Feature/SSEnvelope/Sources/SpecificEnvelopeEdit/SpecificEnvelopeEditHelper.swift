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

public struct SpecificEnvelopeEditHelper: Equatable {
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

    priceProperty = .init(price: envelopeDetailProperty.price)

    eventSectionButtonCustomItem = customEventItem
    eventSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.eventNameTitle,
      items: eventItems,
      isCustomItem: eventSectionButtonCustomItem,
      customTextFieldPrompt: "경조사 이름"
    )

    // 만약 현재 관계가 default 이벤트에 존재 하지 않는다면
    relationSectionButtonCustomItem = customRelationItem

    relationSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.relationTitle,
      items: relationItems,
      isCustomItem: relationSectionButtonCustomItem,
      customTextFieldPrompt: "관계 이름"
    )

    nameEditProperty = .init(textFieldText: envelopeDetailProperty.name)

    dateEditProperty = .init(date: envelopeDetailProperty.date)

    visitedSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.visitedTitle,
      items: VisitedSelectButtonItem.defaultItems(),
      isCustomItem: nil,
      customTextFieldPrompt: nil,
      isEssentialProperty: false
    )

    visitedEditProperty = .init(isVisited: envelopeDetailProperty.isVisited)

    giftEditProperty = .init(gift: envelopeDetailProperty.gift ?? "")

    contactEditProperty = .init(contact: envelopeDetailProperty.contacts ?? "")

    memoEditProperty = .init(memo: envelopeDetailProperty.memo ?? "")
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
    (priceProperty.isValid) &&
      (eventSectionButtonHelper.isValid()) &&
      (nameEditProperty.isValid) &&
      (relationSectionButtonHelper.isValid()) &&
      (memoEditProperty.isValid) &&
      (contactEditProperty.isValid) &&
      (giftEditProperty.isValid) &&
      (visitedEditProperty.isValid)
    // 데이트는 항상 참이니까 제외
  }
}
