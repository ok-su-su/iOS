//
//  SpecificEnvelopeHistoryRouterHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SpecificEnvelopeHistoryRouterHelper: Equatable {
  var specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty
  
  //TODO: API Logic
  init() {
    self.specificEnvelopeHistoryListProperty = .init(envelopePriceProgressProperty: .makeFakeData(), envelopeContent: .fakeData())
  }
  
  init(specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty) {
    self.specificEnvelopeHistoryListProperty = specificEnvelopeHistoryListProperty
  }
}
