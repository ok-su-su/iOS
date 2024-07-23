//
//  FilterProperty.swift
//  Sent
//
//  Created by MaraMincho on 4/30/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Foundation

struct FilterProperty: Equatable {
  var filteredPeople: [SentPerson]
  var filterEnvelopePrice: FilterEnvelopePrice?

  init() {
    filteredPeople = []
    filterEnvelopePrice = nil
  }

  init(filteredPeople: [SentPerson], filterEnvelopePrice: FilterEnvelopePrice? = nil) {
    self.filteredPeople = filteredPeople
    self.filterEnvelopePrice = filterEnvelopePrice
  }

  struct FilterEnvelopePrice: Equatable {
    var maximum: Int64
    var minimum: Int64
  }
}
