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
  var envelopeHistoryEditHelper: SpecificEnvelopeHistoryEditHelper

  init(
    specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty,
    envelopeHistoryEditHelper: SpecificEnvelopeHistoryEditHelper
  ) {
    self.specificEnvelopeHistoryListProperty = specificEnvelopeHistoryListProperty
    self.envelopeHistoryEditHelper = envelopeHistoryEditHelper
  }
}
