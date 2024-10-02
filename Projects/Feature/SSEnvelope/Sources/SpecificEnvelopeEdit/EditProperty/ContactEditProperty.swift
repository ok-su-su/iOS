//
//  ContactEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - ContactEditProperty

struct ContactEditProperty: Equatable, EnvelopeEditPropertiable {
  var contact: String
  let originalContact: String
  init(contact: String?) {
    let contact = contact ?? ""
    self.contact = contact
    originalContact = contact
  }

  var isValid: Bool {
    if !contact.isEmpty {
      return RegexManager.isValidContacts(contact)
    }
    return true
  }

  var isChanged: Bool {
    originalContact != contact
  }

  var isShowToast: Bool {
    if !contact.isEmpty {
      return ToastRegexManager.isShowToastByContacts(contact)
    }
    return false
  }
}
